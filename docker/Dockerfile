# استخدام Python base image
FROM python:3.9-slim

# تحديد working directory
WORKDIR /app

# نسخ متطلبات المشروع
COPY requirements.txt .

# تثبيت المتطلبات
RUN pip install --no-cache-dir -r requirements.txt

# نسخ كل ملفات التطبيق
COPY . .

# فتح البورت
EXPOSE 5000

# تشغيل التطبيق
CMD ["python", "app.py"]
