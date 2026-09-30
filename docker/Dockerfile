# استخدام Python base image
FROM python:3.9-slim

# تحديث حزم النظام لسد الثغرات الأمنية ومسح الكاش
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

# إنشاء مجموعة ومستخدم جديد للأمان (عشان Trivy)
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# تحديد working directory
WORKDIR /app

# نسخ متطلبات المشروع
COPY requirements.txt .

# تحديث أدوات بايثون الأساسية أولاً، ثم تثبيت مكتبات المشروع (عشان Trivy)
RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt

# نسخ كل ملفات التطبيق مع تغيير ملكيتها للمستخدم الجديد
COPY --chown=appuser:appgroup . .

# التبديل إلى المستخدم العادي
USER appuser

# فتح البورت
EXPOSE 5000

# تشغيل التطبيق (وتأكد إن app.py بيعمل run على 0.0.0.0)
CMD ["python", "app.py"]