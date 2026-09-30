# استخدام Python base image
FROM python:3.9-slim

# تحديث حزم النظام الأساسية لسد الثغرات الأمنية ثم مسح الكاش لتقليل مساحة الصورة
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

# إنشاء مجموعة ومستخدم جديد (بدون صلاحيات Root) للأمان
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# تحديد working directory
WORKDIR /app

# نسخ متطلبات المشروع وتثبيتها
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