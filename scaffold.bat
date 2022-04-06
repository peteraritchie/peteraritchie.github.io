dotnet tool install -g wyam.tool 
wyam new -r Blog 
ssh-keygen -t rsa -b 4096 -C "Github-user-email@example.com" -f %userprofile%\keys\gh-pages -N ""

@REM wyam --recipe Blog --theme CleanBlog
@REM wyam preview

@REM OR =============================================
@REM wyam --recipe Blog --theme SolidState -o docs -p