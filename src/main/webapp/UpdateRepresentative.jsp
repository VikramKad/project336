<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, com.myapp.pkg.ApplicationDB"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%
    try {
        // Get form parameters
        String username = request.getParameter("username");
        String newUsername = request.getParameter("new_username"); // New username
        String password = request.getParameter("password");
        String lastName = request.getParameter("last_name");
        String firstName = request.getParameter("first_name");
        String ssn = request.getParameter("ssn");

        // Log parameters for debugging
        System.out.println("Username: " + username);
        System.out.println("New Username: " + newUsername);
        System.out.println("Password: " + password);
        System.out.println("First Name: " + firstName);
        System.out.println("Last Name: " + lastName);
        System.out.println("SSN: " + ssn);

        // Check if the username exists
        if (username != null && !username.isEmpty()) {
            // Database connection setup
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();

            // Prepare the base SQL query for updating the 'accounts' table
            StringBuilder queryAccounts = new StringBuilder("UPDATE accounts SET ");
            boolean firstCondition = true;

            // Add conditions to update only non-null fields in 'accounts'
            if (password != null && !password.isEmpty()) {
                if (!firstCondition) queryAccounts.append(", ");
                queryAccounts.append("password = ?");
                firstCondition = false;
            }
            if (firstName != null && !firstName.isEmpty()) {
                if (!firstCondition) queryAccounts.append(", ");
                queryAccounts.append("first_name = ?");
                firstCondition = false;
            }
            if (lastName != null && !lastName.isEmpty()) {
                if (!firstCondition) queryAccounts.append(", ");
                queryAccounts.append("last_name = ?");
                firstCondition = false;
            }
            if (newUsername != null && !newUsername.isEmpty()) {
                if (!firstCondition) queryAccounts.append(", ");
                queryAccounts.append("username = ?");
            }

            // Add the condition to update the specific username in 'accounts'
            queryAccounts.append(" WHERE username = ?");

            // Prepare the statement for 'accounts' and set the values dynamically
            PreparedStatement psAccounts = con.prepareStatement(queryAccounts.toString());

            // Set parameters for 'accounts'
            int index = 1;
            if (password != null && !password.isEmpty()) {
                psAccounts.setString(index++, password);
            }
            if (firstName != null && !firstName.isEmpty()) {
                psAccounts.setString(index++, firstName);
            }
            if (lastName != null && !lastName.isEmpty()) {
                psAccounts.setString(index++, lastName);
            }
            if (newUsername != null && !newUsername.isEmpty()) {
                psAccounts.setString(index++, newUsername);
            }

            // Set the original username for the WHERE clause
            psAccounts.setString(index, username);

            System.out.println("Accounts Query: " + queryAccounts.toString());
            
            if (!queryAccounts.toString().equals("UPDATE accounts SET  WHERE username = ?")){
            	// Execute the update for 'accounts' table
                int rowsAffectedAccounts = psAccounts.executeUpdate();
                System.out.println("Rows affected in accounts table: " + rowsAffectedAccounts);  // Debugging log
            }

            // If SSN is provided, update the 'representatives' table
            if (ssn != null && !ssn.isEmpty()) {
                String queryReps = "UPDATE representatives SET ssn = ? WHERE username = ?";
                PreparedStatement psReps = con.prepareStatement(queryReps);

                // Set SSN parameter
                psReps.setString(1, ssn);

                // Use newUsername if available, otherwise use username
                if (newUsername != null && !newUsername.isEmpty()) {
                    psReps.setString(2, newUsername);
                } else {
                    psReps.setString(2, username);
                }

                // Print the query and parameters for debugging
                System.out.println("Representatives Query: " + queryReps);
                System.out.println("Representatives Parameters: " + ssn + ", " + (newUsername != null ? newUsername : username));

                // Execute the update for 'representatives' table
                int rowsAffectedReps = psReps.executeUpdate();
                System.out.println("Rows affected in representatives table: " + rowsAffectedReps);  // Debugging log

                psReps.close();
            }

            psAccounts.close();
            db.closeConnection(con);
        } else {
            out.print("Username is required.");
        }
    } catch (Exception e) {
        e.printStackTrace();  // Print the stack trace for debugging
        out.print("Error: " + e.getMessage());
    }
%>

