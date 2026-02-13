# Note Marketplace Data Sync Guide

This document explains how agents can seed the Flashly Notes Marketplace with data from Grail.moe.

## Strategy: Backend Scrape \u0026 SQL Sync

Since browser tools cannot always interact with `localhost` or handle complex logins in automated way, we use a two-step "Backend Sync" process.

### 1. Scrape Content
Use the `read_url_content` tool on a Grail library URL. 
Example URL: `https://grail.moe/library?category=GCE+%27O%27+Levels\u0026keyword=bio\u0026subject=Pure+Biology\u0026page=1\u0026doc_type=Exam+Papers`

### 2. Extract and Insert Data
Extract the document names and PDF links (found in the JSON-like script tags of the page content). Map them to Flashly categories and run the final SQL in the Supabase Editor.

## Initial Sync Data (Bio Exam Papers)

Copy and run the following SQL in your **Supabase SQL Editor** to add the first 10 Biology papers:

```sql
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('PLMGS 2016 Bio Prelim P2 MS', 'https://document.grail.moe/f0c7aec4f29f44e2a4f38e1a7855e8c4.pdf', 'O Level', 'Pure Biology', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('YTSS PURE BIO 1', 'https://document.grail.moe/496e547573c54be4af3e56a005603cd0.pdf', 'O Level', 'Pure Biology', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('YTSS PURE BIO 2', 'https://document.grail.moe/4162c72e489947ef84368a69e289e954.pdf', 'O Level', 'Pure Biology', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('YTSS PURE BIO 3', 'https://document.grail.moe/727acf99964e4beebfa2ee460fe2148a.pdf', 'O Level', 'Pure Biology', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('NCHS Bio Prelim P2 2024', 'https://document.grail.moe/162ba6bad5174407a96f33d24e05f81b.pdf', 'O Level', 'Pure Biology', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('NCHS Bio Prelim P1 2024', 'https://document.grail.moe/cc213e43929146d89e826fe5abac3738.pdf', 'O Level', 'Pure Biology', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('NCHS Bio Prelim P2 2024', 'https://document.grail.moe/1efc689b58b54f7fb2844f5ea629a64a.pdf', 'O Level', 'Pure Biology', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('NCHS Bio Prelim P1 2024', 'https://document.grail.moe/e848aeb82f144f7b9f9399c5c25f5f8d.pdf', 'O Level', 'Pure Biology', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('NCHS Bio Prelim P3 2024', 'https://document.grail.moe/ba13c9d677934e968730f2425265e340.pdf', 'O Level', 'Pure Biology', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('Bio AI 2022 Prelim Ans', 'https://document.grail.moe/de3e4ff870084258a9890d6ef742c929.pdf', 'O Level', 'Pure Biology', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('Bio AI 2022 Prelim P2', 'https://document.grail.moe/0c2b5e9537fe4247a211577c49daf57a.pdf', 'O Level', 'Pure Biology', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('Bio AI 2022 Prelim P1', 'https://document.grail.moe/50e30db0e9df45749ae76f098396d06d.pdf', 'O Level', 'Pure Biology', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('YYSS Pure Bio 2024 P1, P2, MS', 'https://document.grail.moe/ab0fac8ba7aa446683b7b5780bde21f1.pdf', 'O Level', 'Pure Biology', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('NCHS Bio Prelim 2024 Overall Mark Scheme', 'https://document.grail.moe/32c60abe51a44c289924ffdffc19c9be.pdf', 'O Level', 'Pure Biology', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('NCHS Bio Prelim 2024 Overall Mark Scheme', 'https://document.grail.moe/e1ac28b68a48430cb385a48616344179.pdf', 'O Level', 'Pure Biology', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('2025 FUHUA BIO P1 w/ ANS', 'https://document.grail.moe/27c8e8ab7cb042ad9d27a840a50286fa.pdf', 'O Level', 'Pure Biology', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('2025 FH Prelim BIO Paper 2', 'https://document.grail.moe/625b96e7defd442db3324c17b9658f42.pdf', 'O Level', 'Pure Biology', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('Mayflower 2019 Bio Prelim P2 QP', 'https://document.grail.moe/91700b694ebe43f49dbb081a80affb6a.pdf', 'O Level', 'Pure Biology', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('PLMGS 2016 Bio Prelim P2 QP', 'https://document.grail.moe/d884277246484acc88cf26be950037e2.pdf', 'O Level', 'Pure Biology', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('SCGS 2017 Bio Prelim P2 MS', 'https://document.grail.moe/be0fc3e50bf5444a9fcc48b8ec1d76f6.pdf', 'O Level', 'Pure Biology', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('Zhonghua Prelim P1 Ans', 'https://document.grail.moe/f155be6af9f543dea9ac1b26c8afc36e.pdf', 'O Level', 'Pure Chemistry', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('Zhonghua Prelim P1', 'https://document.grail.moe/e65ebc5089d647d78db204834bf370c7.pdf', 'O Level', 'Pure Chemistry', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('Zhonghua Prelim P2 Ans', 'https://document.grail.moe/50e510982143415f86b43c3b694c1c0a.pdf', 'O Level', 'Pure Chemistry', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('Zhonghua Prelim P2', 'https://document.grail.moe/29bca22ca0914e4089cd1fd5669e9ebd.pdf', 'O Level', 'Pure Chemistry', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('YSS 4E Pure Chem Paper 2 Prelim 2024', 'https://document.grail.moe/b057f5c389204285b0725f372cb58172.pdf', 'O Level', 'Pure Chemistry', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('YSS 4E Pure Chem Paper 2 Prelim 2024 MS', 'https://document.grail.moe/6df80160c9d146c5a4df787211ff6fef.pdf', 'O Level', 'Pure Chemistry', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('YSS 4E Pure Chem Paper 1 Prelim 2024', 'https://document.grail.moe/16fdc4d4c2ec4053934853c3b1c48464.pdf', 'O Level', 'Pure Chemistry', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('YSS 4E Pure Chem Paper 1 Prelim 2024 MS', 'https://document.grail.moe/6850010829ab4bd38a7672e6f942ee6b.pdf', 'O Level', 'Pure Chemistry', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('Yuan Ching Prelim Ans', 'https://document.grail.moe/aa13fff573594073af4621c07d3cc969.pdf', 'O Level', 'Pure Chemistry', 'Exam Papers');
INSERT INTO public.notes (title, url, category, subject, type) VALUES ('Yuan Ching Prelim P1', 'https://document.grail.moe/ae5f118ed7ef48b0be8660ec323a2536.pdf', 'O Level', 'Pure Chemistry', 'Exam Papers');
```
