<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>
<%
    // Check session
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get selected category
    String categoryIdParam = request.getParameter("category_Id");
    if (categoryIdParam == null) {
        response.sendRedirect("quiz.jsp");
        return;
    }
    int categoryId = Integer.parseInt(categoryIdParam);

    // DB connection
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    List<Map<String, String>> questions = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/quizzarddb", "root", "");

        ps = conn.prepareStatement("SELECT * FROM quiz_questions WHERE category_id=? ORDER BY RAND() LIMIT 5");
        ps.setInt(1, categoryId);
        rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, String> q = new HashMap<>();
            q.put("id", rs.getString("id"));
            q.put("question", rs.getString("question"));
            q.put("option_a", rs.getString("option_a"));
            q.put("option_b", rs.getString("option_b"));
            q.put("option_c", rs.getString("option_c"));
            q.put("option_d", rs.getString("option_d"));
            q.put("correct_option", rs.getString("correct_option"));
            questions.add(q);
        }

        session.setAttribute("quizQuestions", questions);

    } catch (Exception e) {
        out.println("<p style='color:red;'>Database Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ex) {}
        if (ps != null) try { ps.close(); } catch (Exception ex) {}
        if (conn != null) try { conn.close(); } catch (Exception ex) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Start Quiz | Quizzard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    <style>
        /* Background animation using from/to instead of 0%/100% to avoid JSP parsing issues */
        @keyframes bgShift {
            from { background: linear-gradient(120deg, #ffe4ec, #f3d1ff); }
            to   { background: linear-gradient(120deg, #f7d1ff, #ffd6e8); }
        }

        body {
            background: linear-gradient(120deg, #ffe4ec, #f3d1ff);
            background-attachment: fixed;
            font-family: 'Poppins', sans-serif;
            color: #333;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
            animation: bgShift 10s infinite alternate;
        }

        .container {
            width: 85%;
            max-width: 900px;
            margin: 60px auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            position: relative;
        }

        h2 {
            text-align: center;
            color: #8e24aa;
            font-size: 30px;
            margin-bottom: 25px;
            letter-spacing: 1px;
        }

        .timer {
            position: absolute;
            top: 25px;
            right: 25px;
            background: #f06292;
            color: #fff;
            padding: 10px 20px;
            border-radius: 30px;
            font-weight: bold;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }

        .help-btn {
            position: absolute;
            top: 25px;
            left: 25px;
            background: #8e24aa;
            color: white;
            padding: 8px 18px;
            border: none;
            border-radius: 20px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
        }

        .help-btn:hover {
            background: #ad3fcd;
        }

        .question {
            background: #fff5fb;
            margin-bottom: 25px;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            transition: 0.3s;
        }

        .question:hover {
            transform: scale(1.02);
        }

        .options label {
            display: block;
            background: #ffffff;
            border: 1px solid #f8bbd0;
            padding: 10px;
            margin: 8px 0;
            border-radius: 8px;
            cursor: pointer;
            transition: 0.3s;
        }

        .options input {
            margin-right: 8px;
        }

        .options label:hover {
            background: #f8bbd0;
            color: white;
        }

        .submit-btn {
            background: #ab47bc;
            border: none;
            color: #fff;
            padding: 14px 40px;
            font-size: 16px;
            border-radius: 10px;
            cursor: pointer;
            display: block;
            margin: 30px auto;
            transition: 0.3s;
            box-shadow: 0 3px 10px rgba(0,0,0,0.3);
        }

        .submit-btn:hover {
            background: #8e24aa;
            transform: scale(1.05);
        }

        /* Help Modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }

        .modal-content {
            background: white;
            margin: 10% auto;
            padding: 25px;
            width: 80%;
            max-width: 500px;
            border-radius: 15px;
            text-align: center;
            color: #6a1b9a;
            box-shadow: 0 8px 20px rgba(0,0,0,0.3);
        }

        .close {
            color: #6a1b9a;
            float: right;
            font-size: 22px;
            cursor: pointer;
        }

        .close:hover {
            color: #ad3fcd;
        }
    </style>
</head>

<body>
    <div class="container">
        <button class="help-btn" type="button" onclick="openHelp()">Help</button>
        <div class="timer" id="timer">05:00</div>
        <h2>Take Your Quiz</h2>

        <form id="quizForm" action="submitQuiz.jsp" method="post">
            <% int qNo = 1;
               for (Map<String, String> q : questions) { %>
                <div class="question">
                    <p><b>Question <%= qNo++ %>:</b> <%= q.get("question") %></p>
                    <div class="options">
                        <label><input type="radio" name="q<%= q.get("id") %>" value="A" required> <%= q.get("option_a") %></label>
                        <label><input type="radio" name="q<%= q.get("id") %>" value="B"> <%= q.get("option_b") %></label>
                        <label><input type="radio" name="q<%= q.get("id") %>" value="C"> <%= q.get("option_c") %></label>
                        <label><input type="radio" name="q<%= q.get("id") %>" value="D"> <%= q.get("option_d") %></label>
                    </div>
                </div>
            <% } %>
            <button type="submit" class="submit-btn">Submit Quiz</button>
        </form>
    </div>

    <!-- Help Modal -->
    <div id="helpModal" class="modal" role="dialog" aria-modal="true">
        <div class="modal-content">
            <span class="close" onclick="closeHelp()" aria-label="Close">&times;</span>
            <h3>Quiz Instructions</h3>
            <p>1. Read each question carefully.<br>
               2. Select one correct answer for each question.<br>
               3. You have 5 minutes to complete the quiz.<br>
               4. Your quiz will auto-submit when time is over.<br>
               5. Click Submit once you finish.</p>
        </div>
    </div>

    <script>
        // Timer Logic
        let time = 5 * 60; // 5 minutes
        const timerDisplay = document.getElementById('timer');

        const countdown = setInterval(() => {
            const minutes = Math.floor(time / 60);
            const seconds = time % 60;
            timerDisplay.textContent = String(minutes).padStart(2, '0') + ':' + String(seconds).padStart(2, '0');

            if (time <= 0) {
                clearInterval(countdown);
                alert("Time's up! Submitting your quiz.");
                document.getElementById("quizForm").submit();
            }
            time--;
        }, 1000);

        // Help Modal Logic
        function openHelp() {
            document.getElementById('helpModal').style.display = 'block';
        }

        function closeHelp() {
            document.getElementById('helpModal').style.display = 'none';
        }

        window.onclick = function(event) {
            if (event.target == document.getElementById('helpModal')) {
                closeHelp();
            }
        }
    </script>
</body>
</html>
