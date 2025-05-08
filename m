Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A687828373;
	Thu,  8 May 2025 23:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746745591; cv=none; b=eTgWs3epCRB/18jUbmlU5q2mFe+pacO0jM7fFzfE5SlFiq1C7hR3I7aI35ntrdES9vNfWPoG16O146lGOoKjx6PzzQzEhnJ+y9Yz108t6US9tEVsZfp7/2LuGX6YIF1CVpK5EsMLZgj/yzrEriyXUHuyGFfcyzN+BaY1ggK3oWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746745591; c=relaxed/simple;
	bh=ulMm7rqrJIHKwFX0YK5+lCgp7LyCluFPhyajxVbgkY0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WxR8a21BziJFiK3ksTNR6+iLRhLb9rx6oQ6YQ0JWVoe8ipR40wJmi+/RUcqhYlMXGldEU6erRlWqTmXHU1r5bPxOlaems0eJiOx1WuAaGS4g+TW5EDomlRM534tgpQlZfT2PY6/kHDqxEJt4BSgbhq+3cG6hJ/2wPEtSfN32ItA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-442d146a1aaso13915575e9.1;
        Thu, 08 May 2025 16:06:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746745588; x=1747350388;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FoiIV8FtE0uJRUG8kQVuxMjsT68lmm2YHo//i4ka7q8=;
        b=ZC/s8PyaZegKPg+aBmCmnbStO0jiWibOcJ/Ugaqwk5LN6oGMIYMiaUx6iw99ChBc4f
         Gg3PJYj9YhZCCO7LdnIs7tBQDCcOi4v/VjwIYe9lIf3Stg/09Wb2BOwum17xJjiPkoq/
         YlcNhJHkW+6vwDhY2mHKZVAfA4s2dKzhj4vecKwPW3P7oOZSoopdiclLH54zmk2BmPb5
         s5HAsZz3HDRoalfehI9Txs8SZjN9LPBILF8D3m51gfRMscigokQoUHYK3K+hoz/LVn8D
         DgDsdfVYRMr2LC3YwWECgO+4mSpgKsd1vlLlBDKZx+IfUqZ0eVPwGHflWJiRUqRrz6Ol
         p6bg==
X-Forwarded-Encrypted: i=1; AJvYcCUvsIjhpr0x7vKj1Dr+2EB3yR/fLh4v0xo/fO+lgBBwaBy2MMgp69+OC0FF9sEn7NLh8b+Z9nee8t7o@vger.kernel.org, AJvYcCXBW/V+qbVvUxTqzxDLqQic07J0p3WYmke4EXcAR+dVxo9wVK0tN5Z1hvOtfDxzlh7u4tncumILTL2YkM4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyb7zYt/b+iHEX/tpbWbqFy31EXzu1jWj/bg78zriyH3N6qR3WR
	fGlsgNgImw+ypgXSPqYe5PjSvHRuKhLQYg4PpWBjs1OiDBgd8Dmu
X-Gm-Gg: ASbGnctaK3N1YuJzF9crVI8DAo5xLWel9RQ2mKpsWoV1cds8mJcv/csfb/tRJdYVYzL
	Vk20zmHGvkB75EJvA5Am36TrgGe69udWLnuXQs69Wq9ywJVoDYqkK2kHGxJiwlKWm6ZIvtGL6wF
	S1uYN5wWmj8eVv89egNAEBWxTKGK4FzLZiWsbTi6MgnpBtnHG38jieFTPhz/zyvk3qlCLzCu4rS
	TNcY0LGZEApSfaBtJjwtBioYctihlk2pfKTbNEC9xxFW73sif0fGKVYRif2Z3XBrpGeBgNyMHHs
	bGKq59o9o53f10X7rs18Ahj54kmvWGqadoBYhHPS02cVb5cVOsYS4w==
X-Google-Smtp-Source: AGHT+IHNQzB0xFnmCyeMqMUKurP0DGqMvpxGFvmOZMa5kkoHtMJconRQOqn9jxf3vEjIATr9f9nnKw==
X-Received: by 2002:a05:600c:8707:b0:43c:fd72:f039 with SMTP id 5b1f17b1804b1-442d6d3e13bmr8135445e9.11.1746745587595;
        Thu, 08 May 2025 16:06:27 -0700 (PDT)
Received: from iss.intel.com ([82.213.227.153])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd3aeccdsm50840155e9.32.2025.05.08.16.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 16:06:27 -0700 (PDT)
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
To: x86@kernel.org,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	balrogg@gmail.com
Subject: [PATCH v2] x86/sgx: Prevent attempts to reclaim poisoned pages
Date: Fri,  9 May 2025 01:04:29 +0200
Message-ID: <20250508230429.456271-1-andrew.zaborowski@intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pages used by an enclave only get epc_page->poison set in
arch_memory_failure() but they currently stay on sgx_active_page_list until
sgx_encl_release(), with the SGX_EPC_PAGE_RECLAIMER_TRACKED flag untouched.

epc_page->poison is not checked in the reclaimer logic meaning that, if other
conditions are met, an attempt will be made to reclaim an EPC page that was
poisoned.  This is bad because 1. we don't want that page to end up added
to another enclave and 2. it is likely to cause one core to shut down
and the kernel to panic.

Specifically, reclaiming uses microcode operations including "EWB" which
accesses the EPC page contents to encrypt and write them out to non-SGX
memory.  Those operations cannot handle MCEs in their accesses other than
by putting the executing core into a special shutdown state (affecting
both threads with HT.)  The kernel will subsequently panic on the
remaining cores seeing the core didn't enter MCE handler(s) in time.

Call sgx_unmark_page_reclaimable() to remove the affected EPC page from
sgx_active_page_list on memory error to stop it being considered for
reclaiming.

Testing epc_page->poison in sgx_reclaim_pages() would also work but I assume
it's better to add code in the less likely paths.

The affected EPC page is not added to &node->sgx_poison_page_list until
later in sgx_encl_release()->sgx_free_epc_page() when it is EREMOVEd.
Membership on other lists doesn't change to avoid changing any of the
lists' semantics except for sgx_active_page_list.  There's a "TBD" comment
in arch_memory_failure() about pre-emptive actions, the goal here is not
to address everything that it may imply.

This also doesn't completely close the time window when a memory error
notification will be fatal (for a not previously poisoned EPC page) --
the MCE can happen after sgx_reclaim_pages() has selected its candidates
or even *inside* a microcode operation (actually easy to trigger due to
the amount of time spent in them.)

The spinlock in sgx_unmark_page_reclaimable() is safe because
memory_failure() runs in process context and no spinlocks are held,
explicitly noted in a mm/memory-failure.c comment.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
Changes in v2:
 - improve commit message following Dave Hansen's input: explain why
   the SGX ops crash, replace page with epc_page.  Improve the summary,
   use the right prefix.

 arch/x86/kernel/cpu/sgx/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 671c26513..7076464d4 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -719,6 +719,8 @@ int arch_memory_failure(unsigned long pfn, int flags)
 		goto out;
 	}
 
+	sgx_unmark_page_reclaimable(page);
+
 	/*
 	 * TBD: Add additional plumbing to enable pre-emptive
 	 * action for asynchronous poison notification. Until
-- 
2.43.5

