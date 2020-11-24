Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE0EC2D0E4
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Nov 2020 17:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D3A920757
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Nov 2020 17:50:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="uJq0NQNd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404024AbgKXRuQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 24 Nov 2020 12:50:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:53714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728945AbgKXRuQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 24 Nov 2020 12:50:16 -0500
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E2BB208C3
        for <linux-sgx@vger.kernel.org>; Tue, 24 Nov 2020 17:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606240214;
        bh=Zs6EQHNJCYjsDUBvn/aU7NkdPNq8mmBy6u3ZYrgbcdw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uJq0NQNdWOoPdjsdOd+82dA0M5WwPUd916W+d2js6jxu3ycgv4SJZFMww2yPF9tyQ
         t8yDhNVyxuIlvR3y5BhlL00Wxo91Uw//1ZM8Av5+ZXeux5egUV7Z9MrnmTUj+1XXZM
         OZmujRMlLxxjw+b5FNTq/XDg3m7C2ask7Rrud83s=
Received: by mail-wm1-f54.google.com with SMTP id w24so3806807wmi.0
        for <linux-sgx@vger.kernel.org>; Tue, 24 Nov 2020 09:50:14 -0800 (PST)
X-Gm-Message-State: AOAM532PDSSd/j9glcNTIElWobn0flk/mEfnC/Wt02qf8uTUfvfTQhtN
        9oR696PiPAPMIaO26AO0dnrfKPgVQ2a+HFnSIHbdNg==
X-Google-Smtp-Source: ABdhPJztSaESfwAH1/aRejEPYWeasu3H+2flPGn0gw/HTGKjb5d0CHq2izvTy8vEL8huMDEFbD9KM2+mbalOfiJ1UOk=
X-Received: by 2002:a7b:c92a:: with SMTP id h10mr5811407wml.138.1606240212832;
 Tue, 24 Nov 2020 09:50:12 -0800 (PST)
MIME-Version: 1.0
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com>
 <20201121151259.GA3948@wind.enjellic.com> <5ac4eccb-fcf9-eed3-fcec-b8b6bf56bb39@intel.com>
 <20201124105547.GA19930@wind.enjellic.com>
In-Reply-To: <20201124105547.GA19930@wind.enjellic.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 24 Nov 2020 09:49:59 -0800
X-Gmail-Original-Message-ID: <CALCETrVjBtdE7Px2Ra6ZsabWZCLPq5e5tMPOWoYT=k3dSA8o4g@mail.gmail.com>
Message-ID: <CALCETrVjBtdE7Px2Ra6ZsabWZCLPq5e5tMPOWoYT=k3dSA8o4g@mail.gmail.com>
Subject: Re: [PATCH v40 00/24] Intel SGX foundations
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        "Xing, Cedric" <cedric.xing@intel.com>, chenalexchen@google.com,
        Conrad Parker <conradparker@google.com>, cyhanish@google.com,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com,
        Mikko Ylinen <mikko.ylinen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Nov 24, 2020 at 2:56 AM Dr. Greg <greg@enjellic.com> wrote:
>
> On Sat, Nov 21, 2020 at 08:25:23AM -0800, Dave Hansen wrote:
>

> You will get a fully 'git am' compliant patch, including a changelog.
>
> The changelog was written in a parlance consistent with someone who
> would have a basic understanding of the technology under review.  If
> this entire review and vetting process is being done absent that kind
> of understanding, then the case can be made that the kernel
> development process has larger issues on its hands.

No, it wasn't.

I have a fairly good understanding of SGX, and I told you quite
explicitly what was wrong with your changelog.  Understanding the
sentences you wrote and having the background is not at all the same
thing as extracting meaning from your writing.  Your patch conveyed no
information.  This email you just sent also conveys no information.



>
> Lets be honest though, that is not the case here, we have been talking
> about this issue for over a year, everyone involved with this
> technology knows what the problem is.
>
> Since LKML is copied, the basic issue is as follows:
>
> 1.) SGX as a technology is designed to execute code and operate on
> data in a manner that is confidential to inspection and impervious to
> modification and control by the kernel.
>
> 2.) The mindset of the driver developers is that the kernel should be
> the ultimate authority on what SGX is allowed to do.
>
> The two world views are inherently and technically incompatible and
> lead to a potential security dilemma for the kernel.  We simply
> advocate for an additional level of cryptographic security that
> supplements, not replaces, kernel controls to address this issue.

No, they are not.

The kernel can and will enforce policy on what SGX may do.  Your own
NAKked patch, in fact, does exactly this.  At the same time, SGX
provides security to the contents of enclaves.  These are not mutually
exclusive.


> Our patch has two external functions of around 30 lines (~1 screen)
> each that impact the driver.  The bulk of the 700 lines, all in one
> file, is boilerplate code, largely replicated for each instance,
> needed to read/write sysfs files and maintain four, nearly identical,
> linked lists.  If this is an insurmountable review burden then the
> kernel development process has larger problems on its hands.

Frankly, the largest problem in the kernel development process with
regards to SGX is the distraction created by your emails.  Please just
stop.

If you have something useful to say, distill it down to the smallest
amount of text that actually says what you're trying to say.  And
don't forget the part about "something useful to say".  If you do not
have something useful to say, please don't say it.
