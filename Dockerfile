# Use a base image with Python pre-installed
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file to the container
COPY requirements.txt .

# Install the required dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Django project code to the container
COPY . .

# Set environment variables, if required
# ENV VARIABLE_NAME=value

# Run the DB Migrations
RUN python manage.py migrate

# Run the static collection to load static elements
RUN python manage.py collectstatic

# Expose the port your Django app is running on
EXPOSE 8000

# Run the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
