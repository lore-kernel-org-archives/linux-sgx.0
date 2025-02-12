Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE7B15A8;
	Wed, 12 Feb 2025 00:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739319749; cv=none; b=LqPGeccZtDr8ZHdTobW3J7Oir4zYYSaldPEan80DPrsmz49DTj5PGonds+qhlKh4J8VOM9Y4sSNRKJk7vemx9G+tvjl08bRJF//OS865DdaTjKEL7jrHmTsuIpkab8tl7cdeo8fKtsXWzRieIib//04M4XXY8due2LbqMDNnw+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739319749; c=relaxed/simple;
	bh=YW7cK/oM31vkHrVJh4iKIJ9ZXmUt4M/kqA4TQLnCnf8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hWLxtSlMZCH0kslukk2rlIg0VUCCscvaISFxm9Tb+9qVDlGza7NgBbbUicVpF/O09oDacqhCQ5beho7yeSS/31kSB+xGjF0y6vPQE4hdcxW+P7yZrKv2tZK8sMG0SgSj6mF2rtUKV1vVzBfmLEIdeRL+Qh/NM1WN7nY1uRpObW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-308f71d5efcso20462991fa.3;
        Tue, 11 Feb 2025 16:22:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739319745; x=1739924545;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xrJwy1vi51bKwxVHXs7ZVxiaOa6/rQ1XDuL5HIdbTL0=;
        b=ewdm52j49daEDCEJgJ7NGk5kaSIGUfrKiDYVUQaKK4hb1cnjzgV1akniXbj/6JSGm7
         iLrPcECPpJc3qc2BbSaSewDzkSosYxg00ewYtA5hRWVmtU87kVRzjhFGJCxSADzHnxQf
         RTlfHG63MYD1/OKUmfZyv2KdqECT1PyfY8B7NxRsua6BIOUh3nOoCSNOfHZw/erMZooL
         RUFYagtcWsKttJa0A/7kPlJaVP9sKQXZ9+ZtxbodCdQAoeXpdsHSTrRYpQhXVTZKtTLf
         +4++1Kkli2a4lRFyVMZ2dhJS6auUPaz90HYVJYYeVyyPEU/yl1qXzt5HNZCn4yXJpo6D
         iPpg==
X-Forwarded-Encrypted: i=1; AJvYcCV0vXvQOtawH1UZC41zm6irrkvmHiykrtDYz1PTamJu4Q1Xt+u4UFQgWDVxsNiVTXAMnDJSkc0GMXAW@vger.kernel.org, AJvYcCWwG7nVNk68pWJGoI27Mz7i1JkIY2oZAZrMpOcCOpU6DLk/Le6TffLVKgNR8fhxWtJYo2hbpu9NopGmHd4=@vger.kernel.org
X-Gm-Message-State: AOJu0YygJoaWBADOy8s1F/GUkPNTN4M9a+LNTRn7Tc428fIMCmn7cXiP
	Vnop99YoZhDF67u1NjB+9+KkpEQEcL/jq7Y4G2EXQo/slGps9k1fM8mhnMBkKrZtWA==
X-Gm-Gg: ASbGncsMPdNh9b0rttUFuAzUSpj6Q6d9J9o/ovoGUVrUIsH2easbiaUit8PckfgOytM
	i6zKvwAkTyRpcZVTX7eV4ERU3GYJGOoMRFxiEF4fouok6j/DCgtf8KkMqJWlGmc+u52K77p8On6
	L0GcvEF5888O6YANP9n4yoc4c8ipPva5zXx4ry6NUu321n282fZqqDpQ0la4Wg0qDmoGzgdSuZr
	ud7yzMZikbCNNxU1smuhCAXtdVwHhtN1FSPglbPG2b4LRioOKzZERF6ucdrbO4DYwDzfDLHBO6A
	xbSYf/4CRc4aNqUCkDqPplKbjgc3iefPtP9dfOaqh878zpYd+VwdU5Fls7wCHqe1WnA=
X-Google-Smtp-Source: AGHT+IHJTqVfcenXj3ToNQa1hEEGFMAIDPwpCySH64VgAilCDE4QPk0JKPZYkbgrTtJuSB290gU8EA==
X-Received: by 2002:a05:6512:2394:b0:545:ea9:1a21 with SMTP id 2adb3069b0e04-545180e9275mr194115e87.11.1739319744863;
        Tue, 11 Feb 2025 16:22:24 -0800 (PST)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-545064a48e8sm1088608e87.232.2025.02.11.16.22.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2025 16:22:24 -0800 (PST)
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-308f71d5efcso20462811fa.3;
        Tue, 11 Feb 2025 16:22:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXRsVhPbeVTJSdfdLXzHZCBa16gaEfSfQWWL+l3UbJLgOBU1o/nYDtNXnc0GVIRd90ssFw6gO6bGXMt@vger.kernel.org, AJvYcCXuDuwk1gtlPPq7Q3w4xywLS0xcZpM/4qxFADi9tbs7vOunHvjCh7QGj54Cn/GnWfcjRElu6OMO7AVLPXA=@vger.kernel.org
X-Received: by 2002:a2e:a805:0:b0:300:3a15:8f22 with SMTP id
 38308e7fff4ca-309037d6f62mr5053141fa.21.1739319744487; Tue, 11 Feb 2025
 16:22:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211150150.519006-1-andrew.zaborowski@intel.com> <3bd497be-54d7-43b8-a392-4bf82bf64679@intel.com>
In-Reply-To: <3bd497be-54d7-43b8-a392-4bf82bf64679@intel.com>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Wed, 12 Feb 2025 01:22:13 +0100
X-Gmail-Original-Message-ID: <CAOq732KJ658+mRTZV+SdMRVTdKBUARzWz2WCoTyHqtF98fkdWA@mail.gmail.com>
X-Gm-Features: AWEUYZm0pK47I6I99gyff23lgrIXF-lWEIjWjwb17mqecH7HoHis7I16BOzs44c
Message-ID: <CAOq732KJ658+mRTZV+SdMRVTdKBUARzWz2WCoTyHqtF98fkdWA@mail.gmail.com>
Subject: Re: [PATCH] x86: sgx: Don't track poisoned pages for reclaiming
To: Dave Hansen <dave.hansen@intel.com>
Cc: x86@kernel.org, linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Tony Luck <tony.luck@intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, 
	"H . Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 11 Feb 2025 at 17:25, Dave Hansen <dave.hansen@intel.com> wrote:
>         git log arch/x86/kernel/cpu/sgx/
>
> That usually works for every little nook and cranny of the kernel and
> will show you what the subject rules are.
>
> Could you do that for this patch for v2, please?

My bad, I'll use x86/sgx: ...

>
> Also, this isn't about _tracking_ pages per se. It's avoiding SGX page
> reclaim, don't you think?

Ok, the goal is to avoid the crash so I'll update the subject line.
That said clearing SGX_EPC_PAGE_RECLAIMER_TRACKED for a page that
cannot be reclaimed seems reasonable on its own.

>
> On 2/11/25 07:01, Andrew Zaborowski wrote:
> > Pages used by an enclave only get page->poison set in
>
> Could we please call these "epc_page" instead of "page"?

Ok, makes sense.

>
> > arch_memory_failure() but stay on sgx_active_page_list.
> > page->poison is not checked in the reclaimer logic meaning that a page could be
> > reclaimed and go through ETRACK, EBLOCK and EWB.  This can lead to the
> > firmware receiving and MCE in one of those operations and going into
> > "unbreakable shutdown" and triggering a kernel panic on remaining cores.
>
> This requires low-level SGX implementation knowledge to fully
> understand. Both what "ETRACK, EBLOCK and EWB" are in the first place,
> how they are involved in reclaim and also why EREMOVE doesn't lead to
> the same fate.
>
> Can it be written in a more approachable way?
>
> During SGX reclaim, the CPU actually touches the SGX data page,
> encrypting and writing its contents out to normal memory. These "EWB"
> writeback operations are implemented in what are effectively big,
> complicated chunks of microcode. Any machine checks encountered during
> this writeback operation are usually fatal to the entire system.
>
> If an epc_page has poison, reclaiming it is highly likely to bring the
> whole system down. The SGX reclaim code does not currently check for poison.

Ok, I agree part of this explanation is fit for the commit message.
In a busy area of code I don't think every commit touching it should
explain what the code does but here it makes sense.

As a side note with a set of enclaves fighting badly enough for the
EPC memory the probability of an MCE happening inside one of the EWB
operations can become considerable because of the sheer amount of time
spent in them and I don't think anything can be done about it.

>
> --
>
> > Remove the affected page from sgx_active_page_list but don't add it
> > immediately to &node->sgx_poison_page_list to keep most of the current
> > semantics.
>
> What semantics are being kept? Are they important?

That's a good question.  An epc_page can be on one of 3 or 4 lists, or
none, so the logic is already complicated.  My guess is that moving
the page to &node->sgx_poison_page_list only after EREMOVE is done
adds some order, because functionally it doesn't change anything.
(But __sgx_sanitize_pages skips the EREMOVE for poisoned pages)

So epc_page->poison is used temporarily while the page is mapped into
an enclave.  Once the enclave is released a poisoned page is moved to
sgx_poison_page_list.  The current semantics ensure that by that time
the epc_page is not referenced by an encl_page and is not on any other
list so for all purposes it's forgotten.

>
> > Tested with CONFIG_PROVE_LOCKING as suggested by Tony Luck.
>
> "I tested it with lockdep and it didn't blow up" is definitely better
> than "I booted this and it didn't blow up" or not testing it at all.
>
> But even better would be demonstrating in the changelog that the locking
> rules were understood and respected in this patch.
>
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index 671c26513..7076464d4 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -719,6 +719,8 @@ int arch_memory_failure(unsigned long pfn, int flags)
> >               goto out;
> >       }
> >
> > +     sgx_unmark_page_reclaimable(page);
> > +
> >       /*
> >        * TBD: Add additional plumbing to enable pre-emptive
> >        * action for asynchronous poison notification. Until
>
> I'll 100% buy that this is the most expeditious fix.
>
> But is it the _best_ one?
>
> In the end, this patch has the semantics of avoiding SGX reclaim on
> poisoned pages. Wouldn't it be most straightforward to implement that in
> the SGX *reclaim* code?

I don't know.  If we know we cannot reclaim a page should we force the
reclaimer to still look at its flags?

I'm sure we don't want to have to check epc_page->poison multiple
times if we can remove it from a relevant list once. Perhaps it's not
great that my patch adds a period when the epc_page is not on *any*
list, everywhere else this is done only for very short times.  I'm not
sure what it would take to eremove the page earlier so it can be added
to sgx_poison_page_list, I think the "TBD" comment in
arch_memory_failure() refers to that and I hoped to leave it as a TBD.

Best regards
