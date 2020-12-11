package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
	
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	public UserDAO() {
		try {
			String dbURL = "jdbc:mysql://192.168.99.100:3306/BBS";
			String dbID = "root";
			String dbPassword ="";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL,dbID,dbPassword);
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public int login(String UserID, String UserPassword) {
		String SQL = "SELECT userPassword FROM USER WHERE UserID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, UserID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if(rs.getString(1).equals(UserPassword))
					return 1;
				else
					return 0;
				
			}
			return -1; //no id
		}catch(Exception e) {
		
			e.printStackTrace();
		}
		return -2; //db error
	}
	public int join(User user) {
		String SQL = "INSERT INTO USER VALUES (?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1,  user.getUserID());
			pstmt.setString(2,  user.getUserPassword());
			pstmt.setString(3,  user.getUserName());
			pstmt.setString(4,  user.getUserGender());
			pstmt.setString(5,  user.getUserEmail());
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //db error
		
	}

	
}