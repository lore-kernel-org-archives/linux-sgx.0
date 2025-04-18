Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3809B1DF247
	for <linux-sgx@vger.kernel.org>; Fri, 18 Apr 2025 14:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744988150; cv=none; b=eT6gf+dpI9Qpy5JDjzfMF/AkCGw/ILu8hcuiVIJCNb/tqVENErOpMm2zbEwR8j++kHqi2eWsrcBv8XhwwZ5kCTmonRESo8z/pA9LWh5Apa8an6OUCtFP7cTBUez6EjJ4natatAnzn9WEz2FB18z+re4Slj4qyn+ZIaTJMcls6ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744988150; c=relaxed/simple;
	bh=v5jeM6IdRu5kwslLRf/1pwaSpnFjQBP54ymXQRkSwpw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EiDyhVnan7S5IDd+50RprOPb0ja1eFiM9pYGe4Ty0LkaDKQA0wBntVI2kow1NKc11/2Ob9q8d73RROtk54jJiLY7gdktvJ5SF41rmNpA5+EuYq3I5eS3SXVZefC0SaCkpAj4cbQNbup0HJkHRXtjtpzdetl0JemOSAidaX/k0yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ocG5Sf41; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ocG5Sf41"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-73c09e99069so2258218b3a.0
        for <linux-sgx@vger.kernel.org>; Fri, 18 Apr 2025 07:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744988148; x=1745592948; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ly7clhQPsm7lTpvVytdc3NPdGM80PwA051TLRXYT/cY=;
        b=ocG5Sf41eGPgS3AK8gOmcdyRI7rLiJ8lmppJOHau1T99Xoxo9n2K/6bWV/sw0GALI4
         JSPxKBOuhNtRy0Pp2KoViM6hLLb8tuEcByFd0qIZRSvJQUi1y/kYW5MY3ohtngNmeeg7
         OsndDyhDCM/DygQuPsxMWIpjWXpgJ8h7CqSz6eLNEo7f8WCxdrv6Qt7AoZVFr1qipTjf
         2sFd/ZdYoDlrX0rb56g9FW6uKv73yn1tsGf3qPHM38uqh0e8N0R6aoMsoQCgWlXieLa/
         QIIJAtCPjpaUPdkiIx0lg+1Z28ngdZ/Qdffz/7y3hJ15fNM7ugLLbviLLJHtd80l3Wyt
         c8yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744988148; x=1745592948;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ly7clhQPsm7lTpvVytdc3NPdGM80PwA051TLRXYT/cY=;
        b=XHuxle7KJkjjuYOvjqBUFJMTb7SXsNKT0z+fC+c98foelf9caizTLTX/BFZvx30/ey
         v6iOtAgRHueqK0skRUwhKyGeN0CE9OcHh3xx695Qo6vSGG6eoRgv/3+Pzr4//taMnvEV
         LTSqlP0g69sNRMKBUGRH4pODfg44u7K6gn1y+Pffp3vZ9B1DNwqdBDsCTaK4ZiW7FAPl
         rkFrstMe+eJptjUaJN2KkqJeEgMefdXY/XpJdO05IsEMc9cnIuTpLSBbXH6RDmWYLouM
         nrmasWEISn233yogfgu7CJKdX4UiM9mrWH32AJhslgC2jcST+OZhkMwmEwNx7sCIFcDB
         XgwA==
X-Forwarded-Encrypted: i=1; AJvYcCXBAaftOXRH3N154qaxioXfkwCj5+ddwCMLgg5djARB9f1SFysqTuhmBUdMbA6fbjHlS22EvugIA7E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzhc7mmh33+U5zWxRNXmVkUfnUkFyaaxfc4xxsyOtCneo7PUTPz
	4NWOlfSzqYPZUsuDElvGcXnYDo9uJWgXocm9lLbwee6iJkzfnnoqv2O+02dj4/ln0nSIjAzDaCM
	bow==
X-Google-Smtp-Source: AGHT+IEVtSnImt1uf60rTKZKdHb8P2zBptukIMnlrusgZprIRtXC6rcwSPuw7Yi56KLFkRT360oLGEeGGXE=
X-Received: from pfbhm15.prod.google.com ([2002:a05:6a00:670f:b0:730:8e17:ed13])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1811:b0:736:692e:129
 with SMTP id d2e1a72fcca58-73dc15d0c0fmr4386968b3a.24.1744988148457; Fri, 18
 Apr 2025 07:55:48 -0700 (PDT)
Date: Fri, 18 Apr 2025 07:55:46 -0700
In-Reply-To: <20250415115213.291449-3-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250415115213.291449-1-elena.reshetova@intel.com> <20250415115213.291449-3-elena.reshetova@intel.com>
Message-ID: <aAJn8tgubjT5t7DB@google.com>
Subject: Re: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
From: Sean Christopherson <seanjc@google.com>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: dave.hansen@intel.com, jarkko@kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org, asit.k.mallick@intel.com, 
	vincent.r.scarlata@intel.com, chongc@google.com, erdemaktas@google.com, 
	vannapurve@google.com, dionnaglaze@google.com, bondarn@google.com, 
	scott.raynor@intel.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 15, 2025, Elena Reshetova wrote:
> +/* This lock is held to prevent new EPC pages from being created
> + * during the execution of ENCLS[EUPDATESVN].
> + */
> +static DEFINE_SPINLOCK(sgx_epc_eupdatesvn_lock);
> +
>  static atomic_long_t sgx_nr_used_pages = ATOMIC_LONG_INIT(0);
>  static unsigned long sgx_nr_total_pages;
>  
> @@ -444,6 +449,7 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
>  {
>  	struct sgx_numa_node *node = &sgx_numa_nodes[nid];
>  	struct sgx_epc_page *page = NULL;
> +	bool ret;
>  
>  	spin_lock(&node->lock);
>  
> @@ -452,12 +458,33 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
>  		return NULL;
>  	}
>  
> +	if (!atomic_long_inc_not_zero(&sgx_nr_used_pages)) {

FWIW, the entire automatic scheme has terrible behavior when KVM is running SGX
capable guests.  KVM will allocate EPC when the virtual EPC is first touched by
the guest, and won't free the EPC pages until the VM is terminated.  And IIRC,
userspace (QEMU) typically preallocates the virtual EPC to ensure the VM doesn't
need to be killed later on due to lack of EPC.

I.e. running an SGX capable VM, even if there are no active enclaves in said VM,
will prevent SVN updates.

Unfortunately, I can't think of a sane way around that, because while it would
be easy enough to force interception of ECREATE, there's no definitive ENCLS leaf
that KVM can intercept to detect when an enclave is destroyed (interception
EREMOVE would have terrible performance implications).

That said, handling this deep in the bowels of EPC page allocation seems
unnecessary.  The only way for there to be no active EPC pages is if there are
no enclaves.  As above, virtual EPC usage is already all but guaranteed to hit
false positives, so I don't think there's anything gained by trying to update
the SVN based on EPC allocations.

So rather than react to EPC allocations, why not hook sgx_open() and sgx_vepc_open()?
Then you're hooking a relative slow path (I assume EUPDATESVN is not fast), error
codes can be returned to userspace (if you really want the kernel to freak out if
EUPDATESVN unexpected fails), and you don't _have_ to use a spinlock, e.g. if
EUPDATESVN takes a long time, using a mutex might be desirable.

> +bool sgx_updatesvn(void)
> +{
> +	int retry = 10;
> +	int ret;
> +
> +	lockdep_assert_held(&sgx_epc_eupdatesvn_lock);
> +
> +	if (!(cpuid_eax(SGX_CPUID) & SGX_CPUID_EUPDATESVN))
> +		return true;

Checking CPUID features inside the spinlock is asinine.  They can't change, barring
a misbehaving hypervisor.  This should be a "cache once during boot" sorta thing.

> +
> +	/*
> +	 * Do not execute ENCLS[EUPDATESVN] if running in a VM since
> +	 * microcode updates are only meaningful to be applied on the host.

I don't think the kernel should check HYPERVISOR.  The SDM doesn't actually
say anything about EUPDATESVN, but unless it's explicitly special cased, I doubt
XuCode cares whether ENCLS was executed in Root vs. Non-Root.

It's the hypervisor's responsibility to enumerate SGX_CPUID_EUPDATESVN or not.
E.g. if the kernel is running in a "passthrough" type setup, it would be perfectly
fine to do EUPDATESVN from a guest kernel.  EUPDATESVN could even be proxied,
e.g. by intercepting ECREATE to track EPC usage
