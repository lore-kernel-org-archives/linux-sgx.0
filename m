Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D0234404F
	for <linux-sgx@vger.kernel.org>; Wed, 12 Nov 2025 16:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762963638; cv=none; b=EcwYstH29UnydV1SIVbakkH6d7+se1Z2MKm0souNQbASvuUNmcoV1Z9TtYD6JJc7K9qjxEu2ec5bQO2/JxVfkUDbn/z3w5oojq91/V3oUgNueW4WERXZz+QtLfs6ySxVRfivG56owwfjTvU/XAVkvVfotWOV92LKHuqnEpphJLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762963638; c=relaxed/simple;
	bh=rcoXkrER8UQqtVDDcBsXRfRyMxzZ7C3Dm11vbqk1f6I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QAnImbxJwup1RifCOdu4Pui4/ORoB3+Qx3Fw4SnrLdS+Pm83jw31hJIee0QKsRIFop19juJlj51VTns7J0EOBtarS0PLk7eQ4iEkhosyCTIQjFnZH7EKa44Ht8S/iU+HacHwYEcTcvYK72wTJ17sw8XKlINBISJuuTxKMJm0Was=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g7QUJdO7; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g7QUJdO7"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-297df52c960so22815335ad.1
        for <linux-sgx@vger.kernel.org>; Wed, 12 Nov 2025 08:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762963636; x=1763568436; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bCzRXVVfXNZOo2hC0W4eg4zwEOxmih4nLIdPA+K4xx0=;
        b=g7QUJdO78zoDrjHtnBtlSXGxkEuyHsgjZJjClGhCpNlNHIYUmzFsYaHrq+KwwEHQjg
         vSqFn0y6C/UOQ+o3WEeYlnr+fvs9y2XfwVEbMbIJYsPHihPKEOJikwPuC9Ic8U1Lk9c0
         3WbDtGaE9PBlvnQJlymd2j6iZYHlm2IiY17bLNazPkpmeIETqQZu0JL7SVG2ek8uHGel
         Fi7j+bIvHyb0xtxf4iO2WhYuxsiPJssfdzrCDpiTZIl6KxH64Ubk0lCPSo679ovvAFHb
         QX8N3vyBbZwx+cFRlvnhRBeTQtEuLJYZSW0kfA/L6xS85pOkYlEosBKi+FkTAm8OwJCY
         oAGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762963636; x=1763568436;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bCzRXVVfXNZOo2hC0W4eg4zwEOxmih4nLIdPA+K4xx0=;
        b=DLJ7dUkcEsCK9t0qFXK07w1bOw0GRFuxaP3FB4LdNflkYPBtWDzZ033+4XMEA7GzMy
         kp+Cy+NBb7buh2RqHQgSWEOgU1XxPNqzNRlfaMggOeHKShbB+9qwy8Gaw8FBqcvLmnQk
         T4iQr6LBNYNO2oHrv4orctgAchRuUgJLcKL1mFY5Do3y8UNsGxTKSNE9fsNbmFS5xEqo
         hqpCHd3FDr9vhqcaMF8luJ1eAwKDky6JszSUw8a8UKsAPa5L+9U/NiAExR1usG+Y6wRL
         8d0Xa9wsTj0QGqZVskKmCkwVbtf4r9Znpgn1OwymEr6qD2G/W2uY/gLB8JU3dxEZxLRP
         WO+w==
X-Gm-Message-State: AOJu0YzU4WNPdDrez8Uuh60EIeQ1jb85jSYnErIWvifmI6DRCfCxwQd6
	XDTKVBG4X2NmCP8pWBceCoE+Ze6ODKE6PKEH32RjfmoGVOCMoAIh5BS7lI80oR/nHJmfhTjV9i8
	Pgexmpg==
X-Google-Smtp-Source: AGHT+IGKPunQm5ISPEqmOuS0fN1GRnuQRNFwIf0v6JN1Vqk0oMGs54IRqGDPeVp9726Ni0Fsf0MNaCVFefI=
X-Received: from plhs17.prod.google.com ([2002:a17:903:3211:b0:298:88:c005])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d485:b0:298:33c9:ed91
 with SMTP id d9443c01a7336-2984ede99cfmr43566815ad.32.1762963635961; Wed, 12
 Nov 2025 08:07:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 12 Nov 2025 08:07:06 -0800
In-Reply-To: <20251112160708.1343355-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251112160708.1343355-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251112160708.1343355-4-seanjc@google.com>
Subject: [PATCH 3/5] x86/sgx: Document structs and enums with '@', not '%'
From: Sean Christopherson <seanjc@google.com>
To: Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc: linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Use '@' to document structure members and enum values in kernel-doc markup,
as per Documentation/doc-guide/kernel-doc.rst and flagged by make htmldocs.

  WARNING: arch/x86/include/uapi/asm/sgx.h:17 Enum value 'SGX_PAGE_MEASURE'
           not described in enum 'sgx_page_flags'

Opportunistically add a missing ':' for SGX_CHILD_PRESENT.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/all/20251106145506.145fc620@canb.auug.org.au
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/sgx.h      | 60 ++++++++++++++++-----------------
 arch/x86/include/uapi/asm/sgx.h |  2 +-
 2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index c2c4c0d22ca4..a88c4ab95edd 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -66,19 +66,19 @@ enum sgx_encls_function {
 
 /**
  * enum sgx_return_code - The return code type for ENCLS, ENCLU and ENCLV
- * %SGX_EPC_PAGE_CONFLICT:	Page is being written by other ENCLS function.
- * %SGX_NOT_TRACKED:		Previous ETRACK's shootdown sequence has not
+ * @SGX_EPC_PAGE_CONFLICT:	Page is being written by other ENCLS function.
+ * @SGX_NOT_TRACKED:		Previous ETRACK's shootdown sequence has not
  *				been completed yet.
- * %SGX_CHILD_PRESENT		SECS has child pages present in the EPC.
- * %SGX_INVALID_EINITTOKEN:	EINITTOKEN is invalid and enclave signer's
+ * @SGX_CHILD_PRESENT:		SECS has child pages present in the EPC.
+ * @SGX_INVALID_EINITTOKEN:	EINITTOKEN is invalid and enclave signer's
  *				public key does not match IA32_SGXLEPUBKEYHASH.
- * %SGX_PAGE_NOT_MODIFIABLE:	The EPC page cannot be modified because it
+ * @SGX_PAGE_NOT_MODIFIABLE:	The EPC page cannot be modified because it
  *				is in the PENDING or MODIFIED state.
- * %SGX_INSUFFICIENT_ENTROPY:	Insufficient entropy in RNG.
- * %SGX_NO_UPDATE:		EUPDATESVN could not update the CPUSVN because the
+ * @SGX_INSUFFICIENT_ENTROPY:	Insufficient entropy in RNG.
+ * @SGX_NO_UPDATE:		EUPDATESVN could not update the CPUSVN because the
  *				current SVN was not newer than CPUSVN. This is the most
  *				common error code returned by EUPDATESVN.
- * %SGX_UNMASKED_EVENT:		An unmasked event, e.g. INTR, was received
+ * @SGX_UNMASKED_EVENT:		An unmasked event, e.g. INTR, was received
  */
 enum sgx_return_code {
 	SGX_EPC_PAGE_CONFLICT		= 7,
@@ -96,7 +96,7 @@ enum sgx_return_code {
 
 /**
  * enum sgx_miscselect - additional information to an SSA frame
- * %SGX_MISC_EXINFO:	Report #PF or #GP to the SSA frame.
+ * @SGX_MISC_EXINFO:	Report #PF or #GP to the SSA frame.
  *
  * Save State Area (SSA) is a stack inside the enclave used to store processor
  * state when an exception or interrupt occurs. This enum defines additional
@@ -113,16 +113,16 @@ enum sgx_miscselect {
 
 /**
  * enum sgx_attributes - the attributes field in &struct sgx_secs
- * %SGX_ATTR_INIT:		Enclave can be entered (is initialized).
- * %SGX_ATTR_DEBUG:		Allow ENCLS(EDBGRD) and ENCLS(EDBGWR).
- * %SGX_ATTR_MODE64BIT:		Tell that this a 64-bit enclave.
- * %SGX_ATTR_PROVISIONKEY:      Allow to use provisioning keys for remote
+ * @SGX_ATTR_INIT:		Enclave can be entered (is initialized).
+ * @SGX_ATTR_DEBUG:		Allow ENCLS(EDBGRD) and ENCLS(EDBGWR).
+ * @SGX_ATTR_MODE64BIT:		Tell that this a 64-bit enclave.
+ * @SGX_ATTR_PROVISIONKEY:      Allow to use provisioning keys for remote
  *				attestation.
- * %SGX_ATTR_KSS:		Allow to use key separation and sharing (KSS).
- * %SGX_ATTR_EINITTOKENKEY:	Allow to use token signing key that is used to
+ * @SGX_ATTR_KSS:		Allow to use key separation and sharing (KSS).
+ * @SGX_ATTR_EINITTOKENKEY:	Allow to use token signing key that is used to
  *				sign cryptographic tokens that can be passed to
  *				EINIT as an authorization to run an enclave.
- * %SGX_ATTR_ASYNC_EXIT_NOTIFY:	Allow enclaves to be notified after an
+ * @SGX_ATTR_ASYNC_EXIT_NOTIFY:	Allow enclaves to be notified after an
  *				asynchronous exit has occurred.
  */
 enum sgx_attribute {
@@ -195,7 +195,7 @@ struct sgx_secs {
 
 /**
  * enum sgx_tcs_flags - execution flags for TCS
- * %SGX_TCS_DBGOPTIN:	If enabled allows single-stepping and breakpoints
+ * @SGX_TCS_DBGOPTIN:	If enabled allows single-stepping and breakpoints
  *			inside an enclave. It is cleared by EADD but can
  *			be set later with EDBGWR.
  */
@@ -260,11 +260,11 @@ struct sgx_pageinfo {
 
 /**
  * enum sgx_page_type - bits in the SECINFO flags defining the page type
- * %SGX_PAGE_TYPE_SECS:	a SECS page
- * %SGX_PAGE_TYPE_TCS:	a TCS page
- * %SGX_PAGE_TYPE_REG:	a regular page
- * %SGX_PAGE_TYPE_VA:	a VA page
- * %SGX_PAGE_TYPE_TRIM:	a page in trimmed state
+ * @SGX_PAGE_TYPE_SECS:	a SECS page
+ * @SGX_PAGE_TYPE_TCS:	a TCS page
+ * @SGX_PAGE_TYPE_REG:	a regular page
+ * @SGX_PAGE_TYPE_VA:	a VA page
+ * @SGX_PAGE_TYPE_TRIM:	a page in trimmed state
  *
  * Make sure when making changes to this enum that its values can still fit
  * in the bitfield within &struct sgx_encl_page
@@ -282,14 +282,14 @@ enum sgx_page_type {
 
 /**
  * enum sgx_secinfo_flags - the flags field in &struct sgx_secinfo
- * %SGX_SECINFO_R:	allow read
- * %SGX_SECINFO_W:	allow write
- * %SGX_SECINFO_X:	allow execution
- * %SGX_SECINFO_SECS:	a SECS page
- * %SGX_SECINFO_TCS:	a TCS page
- * %SGX_SECINFO_REG:	a regular page
- * %SGX_SECINFO_VA:	a VA page
- * %SGX_SECINFO_TRIM:	a page in trimmed state
+ * @SGX_SECINFO_R:	allow read
+ * @SGX_SECINFO_W:	allow write
+ * @SGX_SECINFO_X:	allow execution
+ * @SGX_SECINFO_SECS:	a SECS page
+ * @SGX_SECINFO_TCS:	a TCS page
+ * @SGX_SECINFO_REG:	a regular page
+ * @SGX_SECINFO_VA:	a VA page
+ * @SGX_SECINFO_TRIM:	a page in trimmed state
  */
 enum sgx_secinfo_flags {
 	SGX_SECINFO_R			= BIT(0),
diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 0d408f001ac6..3c4d52072189 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -10,7 +10,7 @@
 
 /**
  * enum sgx_page_flags - page control flags
- * %SGX_PAGE_MEASURE:	Measure the page contents with a sequence of
+ * @SGX_PAGE_MEASURE:	Measure the page contents with a sequence of
  *			ENCLS[EEXTEND] operations.
  */
 enum sgx_page_flags {
-- 
2.51.2.1041.gc1ab5b90ca-goog

