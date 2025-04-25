Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE561F4C8E
	for <linux-sgx@vger.kernel.org>; Fri, 25 Apr 2025 19:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745609389; cv=none; b=Z7ygLjsrePGPzADgbbU2zMkfPgB/9lTnpun5xrBP4g6VFIVrt66LtZr2WZeft0iFUf74AukXZ8NJEOwqUilWFsMiXtPdsNHAilCWteyzApgFD8j6FKdHmY/9XhkpPkv6/uLsdQQLrAVKEeh/ThbsPbrpT3C1a9+SZcuJkyBD9VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745609389; c=relaxed/simple;
	bh=8voVrgwPiPoAX5eDLzIarqDTR0MrRNBETTVss6ThFgk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qsxvDJZTk+GqOp6dmXFjh+XPk2hGAElUAMowovzn7BAKgDH/HHLXIkwwIXF/odANt7ecp01Lonhe6fnFgNPivy/RndehnPDneCPlhfF1kaNwRg9J9xTuq+rFFNrEWwt0z5vee0CIYmhlDQkKlgoTSIj9YwxrZ4zNqlc1LEJpOes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d6XHtwsj; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d6XHtwsj"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736c1ea954fso1371692b3a.3
        for <linux-sgx@vger.kernel.org>; Fri, 25 Apr 2025 12:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745609387; x=1746214187; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r0H8wHFyfuUCnuXHDWoCcTcUvUAuMUVgMgpXfwbXFMc=;
        b=d6XHtwsj89leaWCpZjN+uHsilC1iyWcKLeaA4fepiS9hEGb/JIUpGxLpW3S2gINLFy
         M/p8SmKJkAfbboTTQwBxSolfY2K6PhDpyjx93l6/HI/WBvbMXIKJZZZZHvSnex94igIw
         ROZjbTImFLRxCwHzyvWtiowadZKgg521GTszHfzSfWyIltMQ9EoLdAITBCFemqtT01D2
         rIXnMvL+oIzvnqpvnLQiKdfosKGbihz9bzxwpUzUWDbtcj9sQYVoMg21jKrGrApRS5A9
         lk2hpERj76dpiIyogu0Ro5jhDAsY+Wwq8WT+9p/OEUcCGTFVRE0A+EkfUkjdU3gs33yb
         +RCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745609387; x=1746214187;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r0H8wHFyfuUCnuXHDWoCcTcUvUAuMUVgMgpXfwbXFMc=;
        b=IfMTSORNW6CE1W212cwnDqsJArES8QgVqwvyFvCN47lWxV7aWcHWrFG8Z0ateGIvAO
         cmxxPFzEO9rmA+3WYctjRl6OLVaD/7jsRUlWSL+SlzSOmwAJyoSLSb8+dcqlOiZrsbJO
         ospyM4Ke+Xcq7lkQEuyoZYzyNEb+SJGgfH0hGYlByfX0OlhsnCZGvsELF3omv+zNi9W9
         FfnmynAKctj1SM04omph7kJ3jEKmU2odAm2EszRmQK7nWvjYyZv/0TI696sWKSuThFoc
         OjiCAVT11P7J6nrRMD8FUrIKZklDW1JBdyOcbP12/00890l4nZLMIPP5Q5CHUMNB5ARl
         /THg==
X-Forwarded-Encrypted: i=1; AJvYcCWFteBK4gueJOp4TgSiVC3HUP2bNJqUvazqBbwB4cmtCHuLaNN9bO9jdDdm8qluH5rvfhSWxgMjQLI=@vger.kernel.org
X-Gm-Message-State: AOJu0YycYt2idmKYMpjdJcuw0yHku6IydQGhnDuxRUUGuU5QK+NxUd28
	Kkp0IewWE8K2wlSZzEOxoaISZ7LaMjoQUAvU7XIpqSXUgnIo24xMW2XckVWxmkZXhCrh0Bu64xD
	YIg==
X-Google-Smtp-Source: AGHT+IEGQHXaLkkiTs7v0ltelxI7qdyUM/E8TleIGojknWjqEm160xdtk41/4V0Tdb6Ocm2KHbCNuuPA2Mc=
X-Received: from pfbjw11.prod.google.com ([2002:a05:6a00:928b:b0:730:7c03:35e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:c889:b0:1f5:6e71:e45
 with SMTP id adf61e73a8af0-2045b99c0d4mr5026800637.27.1745609386903; Fri, 25
 Apr 2025 12:29:46 -0700 (PDT)
Date: Fri, 25 Apr 2025 12:29:45 -0700
In-Reply-To: <0d7d6b9a-e7bd-4225-8f08-05bd9473a894@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aAJn8tgubjT5t7DB@google.com> <f5cb3c37589791b2004a100ca3ea3deb9e1ae708.camel@intel.com>
 <aAefmNVRFc3me6QQ@google.com> <DM8PR11MB5750B37305B3B1FAE4F42D3AE7852@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aAo_2MPGOkOciNuM@google.com> <DM8PR11MB5750D373790399E324B98A18E7852@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aApgOqHvsYNd-yht@google.com> <DM8PR11MB5750AB0E790096AFF9AFD3AFE7842@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aAutUaQvgEliXPUs@google.com> <0d7d6b9a-e7bd-4225-8f08-05bd9473a894@intel.com>
Message-ID: <aAviqeAdGn-w1GpK@google.com>
Subject: Re: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>, "jarkko@kernel.org" <jarkko@kernel.org>, 
	Kai Huang <kai.huang@intel.com>, 
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, Vincent Scarlata <vincent.r.scarlata@intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, Vishal Annapurve <vannapurve@google.com>, Chong Cai <chongc@google.com>, 
	Asit K Mallick <asit.k.mallick@intel.com>, Erdem Aktas <erdemaktas@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bondarn@google.com" <bondarn@google.com>, 
	"dionnaglaze@google.com" <dionnaglaze@google.com>, Scott Raynor <scott.raynor@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 25, 2025, Dave Hansen wrote:
> On 4/25/25 10:40, Sean Christopherson wrote:
> > So then why on earth is the kernel implementing automatic updates?
> 
> Because it's literally the least amount of code

It's literally not.

This series:

 4 files changed, 104 insertions(+), 20 deletions(-)

The below:

 7 files changed, 94 insertions(+), 15 deletions(-)

And that's not counting the extra code need to return something other than -ENOMEM
when EUPDATESVN fails.

> and doesn't create any new ABI.

It doesn't create new uAPI, but it certainly creates new ABI.  The SVN is visible
to both userspace, and when VMs are in play, the guest and the end customer.
Before this, userspace must explicitly reboot for the SVN to change.  After this,
the SVN will change at a completely opaque time.  Userspace can try to coerce
the kernel into performing an update, but it's not guaranteed to happen.

Even worse, rejecting EPC allocation if EUPDATESVN fails risks breaking existing
setups.

I verified writing the param works as expected, but otherwise untested.

--
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 25 Apr 2025 11:56:08 -0700
Subject: [PATCH] x86/sgx: Implement EUPDATESVN via "module" param

Add support for a new SGX ENCLS instruction, EUPDATESVN, which updates
the Security Version Number (SVN) that's capture in attestation reports.
To succeed, EUPDATESVN requires that there be no active pages in any EPC
section, i.e. there cannot be active enclaves.

Give userspace full control over when updates are attempted, as updates
are typically required only after a corresponding microcode update, e.g.
on the order of every few months or so, and EUPDATESVN is quite slow even
when the SVN isn't changing, i.e. triggering updates automatically isn't
desirable as doing so would negatively impact workloads that spawn enclaves
on-demand.

To ensure no EPC pages are active without introducing overhead in EPC
allocation, which is a hot path, count the number of active enclaves or
virtual EPC instances, and only attempt an update if there are no such
users.  Alternatively, the kernel could track the number of EPC pages that
are allocated,

Note, if the kernel or hardware is buggy and leaks or fails to reap an
EPC page, EUPDATESVN will unexpectedly fail.  But there's nothing that
the update flow can do to resolve such problems.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/sgx.h       | 41 +++++++++++++++---------
 arch/x86/kernel/cpu/sgx/driver.c |  1 +
 arch/x86/kernel/cpu/sgx/encl.c   |  2 ++
 arch/x86/kernel/cpu/sgx/encls.h  |  6 ++++
 arch/x86/kernel/cpu/sgx/main.c   | 54 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h    |  3 ++
 arch/x86/kernel/cpu/sgx/virt.c   |  2 ++
 7 files changed, 94 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 6a0069761508..4329187e085f 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -26,23 +26,26 @@
 #define SGX_CPUID_EPC_SECTION	0x1
 /* The bitmask for the EPC section type. */
 #define SGX_CPUID_EPC_MASK	GENMASK(3, 0)
+/* EUPDATESVN support in CPUID.0x12.0.EAX */
+#define SGX_CPUID_EUPDATESVN	BIT(10)
 
 enum sgx_encls_function {
-	ECREATE	= 0x00,
-	EADD	= 0x01,
-	EINIT	= 0x02,
-	EREMOVE	= 0x03,
-	EDGBRD	= 0x04,
-	EDGBWR	= 0x05,
-	EEXTEND	= 0x06,
-	ELDU	= 0x08,
-	EBLOCK	= 0x09,
-	EPA	= 0x0A,
-	EWB	= 0x0B,
-	ETRACK	= 0x0C,
-	EAUG	= 0x0D,
-	EMODPR	= 0x0E,
-	EMODT	= 0x0F,
+	ECREATE		= 0x00,
+	EADD		= 0x01,
+	EINIT		= 0x02,
+	EREMOVE		= 0x03,
+	EDGBRD		= 0x04,
+	EDGBWR		= 0x05,
+	EEXTEND		= 0x06,
+	ELDU		= 0x08,
+	EBLOCK		= 0x09,
+	EPA		= 0x0A,
+	EWB		= 0x0B,
+	ETRACK		= 0x0C,
+	EAUG		= 0x0D,
+	EMODPR		= 0x0E,
+	EMODT		= 0x0F,
+	EUPDATESVN	= 0x18,
 };
 
 /**
@@ -73,6 +76,11 @@ enum sgx_encls_function {
  *				public key does not match IA32_SGXLEPUBKEYHASH.
  * %SGX_PAGE_NOT_MODIFIABLE:	The EPC page cannot be modified because it
  *				is in the PENDING or MODIFIED state.
+ * %SGX_INSUFFICIENT_ENTROPY:	Insufficient entropy in RNG.
+ * %SGX_EPC_NOT_READY:		EPC is not ready for SVN update.
+ * %SGX_NO_UPDATE:		EUPDATESVN was successful, but CPUSVN was not
+ *				updated because current SVN was not newer than
+ *				CPUSVN.
  * %SGX_UNMASKED_EVENT:		An unmasked event, e.g. INTR, was received
  */
 enum sgx_return_code {
@@ -81,6 +89,9 @@ enum sgx_return_code {
 	SGX_CHILD_PRESENT		= 13,
 	SGX_INVALID_EINITTOKEN		= 16,
 	SGX_PAGE_NOT_MODIFIABLE		= 20,
+	SGX_INSUFFICIENT_ENTROPY	= 29,
+	SGX_EPC_NOT_READY		= 30,
+	SGX_NO_UPDATE			= 31,
 	SGX_UNMASKED_EVENT		= 128,
 };
 
diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 7f8d1e11dbee..b2a19dd7388e 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -37,6 +37,7 @@ static int sgx_open(struct inode *inode, struct file *file)
 	}
 
 	file->private_data = encl;
+	sgx_inc_usage_count();
 
 	return 0;
 }
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 279148e72459..84ca78627e55 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -765,6 +765,8 @@ void sgx_encl_release(struct kref *ref)
 	WARN_ON_ONCE(encl->secs.epc_page);
 
 	kfree(encl);
+
+	sgx_dec_usage_count();
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
index 99004b02e2ed..3d83c76dc91f 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -233,4 +233,10 @@ static inline int __eaug(struct sgx_pageinfo *pginfo, void *addr)
 	return __encls_2(EAUG, pginfo, addr);
 }
 
+/* Update CPUSVN at runtime. */
+static inline int __eupdatesvn(void)
+{
+	return __encls_ret_1(EUPDATESVN, "");
+}
+
 #endif /* _X86_ENCLS_H */
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8ce352fc72ac..e8fcf032e842 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -914,6 +914,59 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
 }
 EXPORT_SYMBOL_GPL(sgx_set_attribute);
 
+static bool sgx_has_eupdatesvn;
+static atomic_t sgx_usage_count;
+static DECLARE_RWSEM(sgx_svn_lock);
+
+void sgx_inc_usage_count(void)
+{
+	if (atomic_inc_not_zero(&sgx_usage_count))
+		return;
+
+	guard(rwsem_read)(&sgx_svn_lock);
+
+	atomic_inc(&sgx_usage_count);
+}
+
+void sgx_dec_usage_count(void)
+{
+	atomic_dec(&sgx_usage_count);
+}
+
+static int sgx_update_svn(const char *buffer, const struct kernel_param *kp)
+{
+	int r;
+
+	if (!sgx_has_eupdatesvn)
+		return -EOPNOTSUPP;
+
+	guard(rwsem_write)(&sgx_svn_lock);
+
+	if (atomic_read(&sgx_usage_count))
+		return -EBUSY;
+
+	r = __eupdatesvn();
+	switch (r) {
+	case 0:
+	case SGX_NO_UPDATE:
+		return 0;
+	case SGX_INSUFFICIENT_ENTROPY:
+		return -EAGAIN;
+	default:
+		ENCLS_WARN(r, "EUPDATESVN");
+		return -EIO;
+	}
+}
+
+static const struct kernel_param_ops sgx_update_svn_ops = {
+	.set = sgx_update_svn,
+};
+
+#undef MODULE_PARAM_PREFIX
+#define MODULE_PARAM_PREFIX "sgx."
+device_param_cb(update_svn, &sgx_update_svn_ops, NULL, 0200);
+__MODULE_PARM_TYPE(update_svn, "bool");
+
 static int __init sgx_init(void)
 {
 	int ret;
@@ -947,6 +1000,7 @@ static int __init sgx_init(void)
 	if (sgx_vepc_init() && ret)
 		goto err_provision;
 
+	sgx_has_eupdatesvn = (cpuid_eax(SGX_CPUID) & SGX_CPUID_EUPDATESVN);
 	return 0;
 
 err_provision:
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index d2dad21259a8..4f4ed042f1d6 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -102,6 +102,9 @@ static inline int __init sgx_vepc_init(void)
 }
 #endif
 
+void sgx_inc_usage_count(void);
+void sgx_dec_usage_count(void);
+
 void sgx_update_lepubkeyhash(u64 *lepubkeyhash);
 
 #endif /* _X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 7aaa3652e31d..f57f1270033c 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -255,6 +255,7 @@ static int sgx_vepc_release(struct inode *inode, struct file *file)
 	xa_destroy(&vepc->page_array);
 	kfree(vepc);
 
+	sgx_dec_usage_count();
 	return 0;
 }
 
@@ -269,6 +270,7 @@ static int sgx_vepc_open(struct inode *inode, struct file *file)
 	xa_init(&vepc->page_array);
 
 	file->private_data = vepc;
+	sgx_inc_usage_count();
 
 	return 0;
 }

base-commit: a33b5a08cbbdd7aadff95f40cbb45ab86841679e
-- 

