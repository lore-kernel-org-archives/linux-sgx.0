Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC16418FC86;
	Fri, 16 Jan 2026 03:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768535960; cv=none; b=EcVSe+TDF2unUIAgqvQC6YgtSTY6UZYK5JEHqr8HmTjHomfitmbmHI7O2HGle0sJfD9DemnAdA94wtTB0Y5dLrAklIIMxig9c/cUJdCPkgpvsMNXSCodJxtR3sMDwpB+I3Vwj5uc0iCpQP3ENyr4cCybQvzcrr9jWnT1ySh7YP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768535960; c=relaxed/simple;
	bh=AICLO5ZAu6nLV8mhaBxRE/823PJLiUpsZLnGepU2U4c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mBJUOB0M69XbdNgGKtAiSP2iNK6fOa76rOyWYiRKjXFflhxhMmsbNcc+8UdyFwmHi0ssyxJ+PY32Yx1nF3MI1Kqo2zVnoPt9JXVLvBjNZqUjXVNfcJTxp/lzqas7zaZeW2WzWKKoh9Zq0/NVoNFFk030tTXXSMaBg7mbY/pi1zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=fqlYnfj6; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="fqlYnfj6"
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60G1PGpC3731818;
	Thu, 15 Jan 2026 19:58:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=dHGRhzLgkzKeDXXU7flt1GDfOTT0CygaMj6S64Q4pTc=; b=fqlYnfj6EMX4
	bj3tSTYHng3FQ0Bf947bM2ssXqvZopiMWPDzpxDzX2nS039HHECHBbo3lvqpnSHd
	IEEtsVWLM+eLyppNNZVj+SawBw9+fJjte7Izpx4OB46c0vY8BgSkPpTvnILQiMCb
	yhX8HvLIVn3K+bLF/WZtXg8sU4MSl3MbGEm13Hr4LFjNIL84klNeJB9xWvsHeBOm
	WJkiuoS1g4FD1HqmTy/FK5CmFIRQY/j4cZj00xiY+xrfLSi3f9LtaM1UQgATOqke
	T7/d8qFfDN7WxPEiY+9T2IHzxCzcub/1OL4jsGrpBJNpOzR/CvJjmyRxcUzVTBhr
	It1bGnlrgQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4bq9ag9nnu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 15 Jan 2026 19:58:29 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Fri, 16 Jan 2026 03:58:26 +0000
From: Chris Mason <clm@meta.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Chris Mason <clm@meta.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter
 Zijlstra (Intel)" <peterz@infradead.org>,
        Theodore Ts'o <tytso@mit.edu>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li
	<xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski
	<luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov
	<bp@alien8.de>, Brian Gerst <brgerst@gmail.com>,
        Dave Hansen
	<dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, James Morse
	<james.morse@arm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Josh Poimboeuf
	<jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>,
        Nam Cao
	<namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Perry Yuan
	<perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth
	<thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-sgx@vger.kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH v4.1 03/10] x86/entry/vdso: refactor the vdso build
Date: Thu, 15 Jan 2026 19:58:02 -0800
Message-ID: <20260116035807.2307742-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260106211856.560186-3-hpa@zytor.com>
References:
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: gO_gaMacYXfmKyVJzFFoBcI-MgI-l0Zn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDAyOSBTYWx0ZWRfX9R0dUwIcoC1s
 V3qPIGKgm+5mos7jnG6JLCRjUacIC1ZjKPEog3Lbo/0nZGNgBw9hjhY/vLKmJBMtGgzu1jnU2JD
 e+kTo64mrR3uqSwG5TeuvrCVqXcUHkzFRbd+cdeQpiJPlrJ3vG8twZVabJQ2284meLLOjmEX7Sx
 C4o67/vH60Tn5cjaf+MhpjJGVD4xuiCU5wx0RI9QxjJaM5NsVXkHqFmUZObVCEfd9mv5ji1IT15
 FJdAeSo8TtY4ltxTw7dUyBEN0Im86gQDZnvm96j2GkG+BhdVb/dlW1SfzRF0IRSQLipHv+B5x6h
 RtXAjdZGKhYJ2+Csby0w1BtaFBZFEDX/s1DL7PZt3n96OKuoqkwMeAJvjrHqrBjegED41VfegGX
 OGJPIJZBOw/rMoYubY0oqifPDGrMbAJPY8kbJvhD74qf9E7i22ffenqZSuJzc4uzsz1/8IrFStK
 JNSm/GI5KntmKxacbBw==
X-Authority-Analysis: v=2.4 cv=B7i0EetM c=1 sm=1 tr=0 ts=6969b765 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=oGMlB6cnAAAA:8
 a=XiQ4jqB30v8HiKyIVqUA:9 a=NdAtdrkLVvyUPsUoGJp4:22
X-Proofpoint-GUID: gO_gaMacYXfmKyVJzFFoBcI-MgI-l0Zn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_01,2026-01-15_02,2025-10-01_01

On Tue,  6 Jan 2026 13:18:36 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:

Hi everyone,

I ran the tip master branch through my AI review prompts and this one was
flagged.  These look right to me, apologies if it's noise:

> diff --git a/arch/x86/entry/vdso/common/Makefile.include b/arch/x86/entry/vdso/common/Makefile.include
> new file mode 100644
> index 0000000000000..3514b4a6869b7
> --- /dev/null
> +++ b/arch/x86/entry/vdso/common/Makefile.include

[ ... ]

> +#
> +# Options from KBUILD_[AC]FLAGS that should *NOT* be kept
> +#
> +flags-remove-y += \
> +	-D__KERNEL__ -mcmodel=kernel -mregparm=3 \
> +	-fno-pic -fno-PIC -fno-pie fno-PIE \
                                  ^^^^^^^

Should this be "-fno-PIE" with the leading dash? The other flags in this
line all have the dash prefix, but "fno-PIE" is missing it. Without the
dash, filter-out won't match the actual compiler flag.

> +	-mfentry -pg \
> +	$(RANDSTRUCT_CFLAGS) $(GCC_PLUGIN_CFLAGS) $(KSTACK_ERASE_CFLAGS) \
                              ^^^^^^^^^^^^^^^^^

Is GCC_PLUGIN_CFLAGS the right variable name here? The kbuild system
defines GCC_PLUGINS_CFLAGS (with an 's') in scripts/Makefile.gcc-plugins.
Other vDSO Makefiles (arm64, sparc, arm) use GCC_PLUGINS_CFLAGS. Without
the fix, gcc plugin flags won't be filtered out when CONFIG_GCC_PLUGINS=y.

> +	$(RETPOLINE_CFLAGS) $(CC_FLAGS_LTO) $(CC_FLAGS_CFI) \
> +	$(PADDING_CFLAGS)

[ ... ]

> +# Reset cf protections enabled by compiler default
> +flags-y += $(call cc-option, -fcf-protection=none)
> +flags-$(X86_USER_SHADOW_STACK) += $(call cc-option, -fcf-protection=return)
           ^^^^^^^^^^^^^^^^^^^^^

Should this be CONFIG_X86_USER_SHADOW_STACK? The Kconfig symbol is defined
as "config X86_USER_SHADOW_STACK" and kbuild exposes it as a CONFIG_
prefixed variable. The next lines show the pattern:

> +# When user space IBT is supported, enable this.
> +# flags-$(CONFIG_USER_IBT) += $(call cc-option, -fcf-protection=branch)
> +
> +flags-$(CONFIG_MITIGATION_RETPOLINE) += $(RETPOLINE_VDSO_CFLAGS)

Both of these correctly use the CONFIG_ prefix. Without it, the shadow
stack cf-protection flag will never be added to vDSO builds even when
CONFIG_X86_USER_SHADOW_STACK=y.


