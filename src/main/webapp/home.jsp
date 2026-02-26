<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="true" %>
<html>
<head>
    <title>Home | Quizzard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            margin: 0;
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #fff0f5, #ffe4f0);
            color: #333;
        }

        /* Navbar */
        .navbar {
            background: linear-gradient(135deg, hotpink, deeppink);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 50px;
            box-shadow: 0px 3px 10px rgba(0,0,0,0.2);
        }

        .navbar h1 {
            color: white;
            font-size: 26px;
            letter-spacing: 1px;
        }

        .nav-links {
            display: flex;
            gap: 30px;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            font-size: 16px;
            transition: 0.3s ease;
        }

        .nav-links a:hover {
            color: #ffe4f0;
            text-decoration: underline;
        }

        /* Hero Section */
        .hero {
            text-align: center;
            padding: 80px 20px;
            background: url('images/proa.jpg') no-repeat center center/cover;
            color: white;
            position: relative;
        }

        .hero::before {
            content: "";
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background-color: rgba(0,0,0,0.5);
            z-index: 1;
        }

        .hero-content {
            position: relative;
            z-index: 2;
        }

        .hero h2 {
            font-size: 38px;
            margin-bottom: 10px;
        }

        .hero p {
            font-size: 18px;
            color: #fdddf6;
        }

        /* Dashboard Layout */
        .dashboard {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 40px;
            padding: 60px 80px;
            justify-items: center;
        }

        /* Card Styling */
        .card {
            background: #fff;
            border-radius: 15px;
            overflow: hidden;
            text-align: center;
            width: 320px;
            box-shadow: 0px 6px 18px rgba(0, 0, 0, 0.15);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
        }

        .card:hover {
            transform: translateY(-10px);
            box-shadow: 0px 10px 25px rgba(0, 0, 0, 0.3);
        }

        .card img {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }

        .card-content {
            padding: 20px;
        }

        .card-content h3 {
            color: deeppink;
            margin-bottom: 10px;
            font-size: 20px;
        }

        .card-content p {
            color: #666;
            font-size: 14px;
        }

        /* Footer */
        footer {
            background: #2c2c2c;
            color: white;
            text-align: center;
            padding: 15px;
            font-size: 14px;
            letter-spacing: 0.5px;
        }

        footer span {
            color: hotpink;
        }
    </style>
</head>
<body>
    <%
        String username = (String) session.getAttribute("username");
        String fullname = (String) session.getAttribute("fullname");

        if (username == null) {
            response.sendRedirect("login.jsp");
        }
    %>

    <!-- Navigation Bar -->
    <div class="navbar">
        <h1>🎯 Quizzard</h1>
        <div class="nav-links">
            <a href="home.jsp"><i class="fa-solid fa-house"></i> Home</a>
            <a href="profile.jsp"><i class="fa-solid fa-user"></i> Profile</a>
            <a href="logout.jsp"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </div>
    </div>

    <!-- Hero Section -->
    <div class="hero">
        <div class="hero-content">
            <h2>Welcome back, <%= fullname != null ? fullname : username %>! 💫</h2>
             <p>Ready to test your knowledge and climb the leaderboard?</p>
        </div>
    </div>

    <!-- Dashboard Cards -->
    <div class="dashboard">
        <div class="card" onclick="window.location.href='profile.jsp'">
            <img src="images/profile-card.webp" alt="Profile">
            <div class="card-content">
                <h3><i class="fa-solid fa-user-circle"></i> View Profile</h3>
                <p>Manage your details and track your quiz journey.</p>
            </div>
        </div>

        <div class="card" onclick="window.location.href='quiz.jsp'">
            <img src="images/quiz-card.webp" alt="Quiz">
            <div class="card-content">
                <h3><i class="fa-solid fa-pen-to-square"></i> Take Quizzes</h3>
                <p>Challenge yourself with exciting quizzes and new topics.</p>
            </div>
        </div>

        <div class="card" onclick="window.location.href='scores.jsp'">
            <img src="images/score-card.webp" alt="Scores">
            <div class="card-content">
                <h3><i class="fa-solid fa-chart-line"></i> View Scores</h3>
                <p>Analyze your results and improve with every challenge.</p>
            </div>
        </div>

        <div class="card" onclick="window.location.href='leaderboard.jsp'">
            <img src="images/leaderboard-card.jpg" alt="Leaderboard">
            <div class="card-content">
                <h3><i class="fa-solid fa-trophy"></i> Leaderboard</h3>
                <p>Compete with others and climb the global leaderboard!</p>
            </div>
        </div>

        <div class="card" onclick="window.location.href='certificate.jsp'">
            <img src="images/certifiacate-card.jpg" alt="Certificate">
            <div class="card-content">
                <h3><i class="fa-solid fa-certificate"></i> Earn Certificates</h3>
                <p>Get certified for your hard work and achievements.</p>
            </div>
        </div>

        <div class="card" onclick="window.location.href='community.jsp'">
            <img src="images/community-card.jpg" alt="Community">
            <div class="card-content">
                <h3><i class="fa-solid fa-comments"></i> Community</h3>
                <p>Collaborate, discuss, and learn with passionate quizzers.</p>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        © 2025 <span>Quizzard</span> | Learn Smarter, Play Harder 💡
    </footer>
</body>
</html>
