# BeOnTime
Helping students be on time in their courses!

Repository for the app BeOnTime, by Jessie Chen, Miranda Luo, Miranda Medina, and Coco Xu for the Cornell AppDev challenge.

Design: Miranda Medina

iOS: Jessie Chen

Backend: Miranda Luo, Coco Xu

## Description
This app is meant for students of Cornell University to keep track of assignments and due dates for their courses in school. Students can add courses from the class roster, and add assignments to their classes and their due dates. They can also track if the assignments are done or not.

## Design Markup
https://www.figma.com/file/EcvXbDWQLv45ku3qQ4iYFR/BeOnTime-Mockup?node-id=0%3A1

## iOS Information

iOS code is in the "iOS" folder.

## Backend API documentation:

https://documenter.getpostman.com/view/14753301/TzRUA75X


iOS: 
Layout: NSLayoutConstraint for everything
Navigation: pushViewController for each button on the home page, pushViewController for each cell in the courseTableCellView and the assignmentTableCellView.
UITableView: Two UITableViews, one for courses and one for assignments
API: for login & register page (.post method), add courses(.post method)
