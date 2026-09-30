# استخدام Python base image
FROM python:3.9-slim

# إنشاء مجموعة ومستخدم جديد (بدون صلاحيات Root) للأمان
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# تحديد working directory
WORKDIR /app

# نسخ متطلبات المشروع وتثبيتها بصلاحيات الـ Root (لتتمكن من الكتابة في ملفات النظام)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# نسخ كل ملفات التطبيق مع تغيير ملكيتها للمستخدم الجديد
COPY --chown=appuser:appgroup . .

# التبديل إلى المستخدم العادي قبل تشغيل التطبيق
USER appuser

# فتح البورت
EXPOSE 5000

# تشغيل التطبيق
CMD ["python", "app.py"]