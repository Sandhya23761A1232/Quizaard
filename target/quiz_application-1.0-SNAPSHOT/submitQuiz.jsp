<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String, String>> questions = (List<Map<String, String>>) session.getAttribute("quizQuestions");
    if (questions == null) {
        response.sendRedirect("quiz.jsp");
        return;
    }

    int score = 0;
    int total = questions.size();

    for (Map<String, String> q : questions) {
        String userAnswer = request.getParameter("q" + q.get("id"));
        String correctAnswer = q.get("correct_option");
        if (userAnswer != null && userAnswer.equalsIgnoreCase(correctAnswer)) {
            score++;
        }
    }

    double percentage = (double) score / total * 100;

    // ? Save results to database
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/quizzarddb", "root", "");
        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO quiz_results(username, score, total, percentage, taken_on) VALUES(?,?,?,?,NOW())"
        );
        ps.setString(1, username);
        ps.setInt(2, score);
        ps.setInt(3, total);
        ps.setDouble(4, percentage);
        ps.executeUpdate();
        ps.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    session.removeAttribute("quizQuestions");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Quiz Results | Quizzard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #f8bbd0, #f3c5f7, #f8a1d1);
            font-family: 'Poppins', sans-serif;
            color: #333;
            text-align: center;
            margin: 0;
            padding: 80px 0;
        }

        .navbar {
            position: fixed;
            top: 0;
            width: 100%;
            background: linear-gradient(90deg, #f48fb1, #ce93d8);
            color: white;
            padding: 15px 20px;
            font-size: 18px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar .title {
            font-weight: 600;
            letter-spacing: 1px;
        }

        .profile {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 500;
        }

        .profile img {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            border: 2px solid white;
            object-fit: cover;
        }

        .result-box {
            background: #ffffff;
            display: inline-block;
            padding: 50px 70px;
            border-radius: 25px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.25);
            margin-top: 100px;
        }

        .result-box h2 {
            font-size: 30px;
            color: #ad1457;
            margin-bottom: 30px;
        }

        .score-circle {
            position: relative;
            width: 150px;
            height: 150px;
            margin: 0 auto 20px;
        }

        .score-circle svg {
            transform: rotate(-90deg);
        }

        .circle-bg {
            fill: none;
            stroke: #f3e5f5;
            stroke-width: 15;
        }

        .circle-progress {
            fill: none;
            stroke: #ec407a;
            stroke-width: 15;
            stroke-linecap: round;
            transition: stroke-dashoffset 1s ease-in-out;
        }

        .score-text {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 26px;
            font-weight: bold;
            color: #ad1457;
        }

        .score-summary {
            font-size: 20px;
            margin: 15px 0;
            color: #555;
        }

        .remark {
            font-size: 18px;
            margin-bottom: 30px;
            color: #777;
        }

        a {
            display: inline-block;
            margin: 12px;
            padding: 12px 35px;
            background: #ec407a;
            color: #fff;
            border-radius: 10px;
            text-decoration: none;
            font-weight: bold;
            transition: 0.3s;
        }

        a:hover {
            background: #d81b60;
        }

        footer {
            margin-top: 50px;
            font-size: 14px;
            color: #888;
        }
    </style>
</head>
<body>

    <div class="navbar">
        <div class="title">Quizzard | Quiz Results</div>
        <div class="profile">
            <img src="images/profile-card.webp" alt="Profile">
            <span><%= username %></span>
        </div>
    </div>

    <div class="result-box">
        <h2>Quiz Completed</h2>

        <div class="score-circle">
            <svg width="150" height="150">
                <circle class="circle-bg" cx="75" cy="75" r="60" />
                <circle class="circle-progress" cx="75" cy="75" r="60" 
                    stroke-dasharray="377"
                    stroke-dashoffset="<%= 377 - (377 * percentage / 100) %>" />
            </svg>
            <div class="score-text"><%= (int) percentage %>%</div>
        </div>

        <p class="score-summary">You scored <strong><%= score %></strong> out of <strong><%= total %></strong></p>

        <p class="remark">
            <% if (percentage == 100) { %> Excellent! You nailed it! 
            <% } else if (percentage >= 80) { %> Great job! You really know your stuff! 
            <% } else if (percentage >= 50) { %> Good effort! Keep practicing. 
            <% } else { %> Don?t worry, you?ll improve with more practice! 
            <% } %>
        </p>

        <a href="quiz.jsp">Take Another Quiz</a>
        <a href="home.jsp">Go to Home</a>
    </div>

    <footer>
        © 2025 Quizzard | Learn Smart, Play Hard
    </footer>

</body>
</html>
