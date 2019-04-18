Return-Path: <SRS0=EsRn=SU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D644BC10F0E
	for <linux-sgx@archiver.kernel.org>; Thu, 18 Apr 2019 18:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E3F2214DA
	for <linux-sgx@archiver.kernel.org>; Thu, 18 Apr 2019 18:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555611710;
	bh=IpRhbSjXtgRtUXeY/pxMzOVKIZHWLd27A1JF0KHnLqg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=0g3wGngF0VNLv9yEpaRPKqvRQP2pF+aSpfRxvlS4bQA6I09E/6bMDIGG+8gYugApJ
	 lVAkPHTYdtJpfKDmBZmesaXQfBZi0/1YIdETmgyT3JQJAITPP8Ma02O71JM7nuiqTR
	 HOD047QYku34aofKczti77TE+nIJeCL7hmQtEs8c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391376AbfDRSVu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 18 Apr 2019 14:21:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391326AbfDRSHc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 18 Apr 2019 14:07:32 -0400
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1678421920
        for <linux-sgx@vger.kernel.org>; Thu, 18 Apr 2019 18:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555610851;
        bh=IpRhbSjXtgRtUXeY/pxMzOVKIZHWLd27A1JF0KHnLqg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jj8ygHs04wG9j5d4K0G7J5sMz+T6/wAqE1jCXlg29NytzVFK613HF9uk5x+gyXqas
         0XhPiTjbZrmVLbaufp4TCpk2F1cW9LBQ6mrfaxyAMJofUznuajPLHoGDmkD7PygwoP
         3+PiMh5L72DrgaPukpMjJ6Rit2WeJzhEkqb3DhN8=
Received: by mail-wr1-f41.google.com with SMTP id w16so4076981wrl.1
        for <linux-sgx@vger.kernel.org>; Thu, 18 Apr 2019 11:07:30 -0700 (PDT)
X-Gm-Message-State: APjAAAVeSBE2zbK6i2u2N+Ya1gv3cf/FtjKjZNJP1MloBJwMpW/z2qDj
        9wqnPstbN0L1X7haPN7mv7hmm54WcLU+SOQqsJ7tZQ==
X-Google-Smtp-Source: APXvYqwNilIIJls/LaAxD1SFXJmD/wO12eJizVP9CrQzNbWzW9bYR3/7nK0huK0vOCEsxKkHQWV3R6mQ6UbX+vhHTjQ=
X-Received: by 2002:adf:f344:: with SMTP id e4mr995076wrp.77.1555610849447;
 Thu, 18 Apr 2019 11:07:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com> <20190418171059.GA20819@wind.enjellic.com>
In-Reply-To: <20190418171059.GA20819@wind.enjellic.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 18 Apr 2019 11:07:17 -0700
X-Gmail-Original-Message-ID: <CALCETrXSFh2v9WZe9c1sT3w6di7uvk4j2fk6bGdb6YT4=rrHdQ@mail.gmail.com>
Message-ID: <CALCETrXSFh2v9WZe9c1sT3w6di7uvk4j2fk6bGdb6YT4=rrHdQ@mail.gmail.com>
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Lutomirski <luto@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Apr 18, 2019 at 10:11 AM Dr. Greg <greg@enjellic.com> wrote:
>
> On Wed, Apr 17, 2019 at 01:39:10PM +0300, Jarkko Sakkinen wrote:
>
> Good morning, I hope this note finds the impending end of the work
> week going well for everyone.
>
> First of all, a thank you to Jarkko for his efforts in advancing this
> driver, a process that can be decidedly thankless.  Our apologies in
> advance for contributing to this phenomenon.
>
> > Intel(R) SGX is a set of CPU instructions that can be used by
> > applications to set aside private regions of code and data. The code
> > outside the enclave is disallowed to access the memory inside the
> > enclave by the CPU access control.  In a way you can think that SGX
> > provides inverted sandbox. It protects the application from a
> > malicious host.
>
> Unfortunately, in its current implementation, the driver will not
> protect a host from malicious enclaves.  If it advances in its current
> form, the mainline Linux kernel will be implementing a driver with
> known and documented security issues.

"I can use this kernel or CPU feature to do something unpleasant that
I could do anyway, if less nicely" is a far cry from "known and
documented security issues".

We've hashed this out to death.  Once SGX is upstream, feel free to
submit patches.

>
> In addition, the driver breaks all existing SGX software by breaking
> compatibility with what is a 3+ year ABI provided by the existing
> driver.  This seems to contravene the well understood philosophy that
> Linux doesn't, if at all possible, break existing applications,
> something that we believe can be easily prevented if those interested
> in these issues choose to read on.

As I understand it, Cedric is going to submit a patch for this
shortly, assuming I have correctly guessed what supposed ABI break
you're talking about.

In the mean time, I need to correct you on a critical point.  Linux
has *never* had a policy that it will retain compatibility with an API
that wasn't upstream in the first place.

[removed extensive verbiage.  Dr. Greg, if you want your emails to be
read, please try to be more concise, and please try to repeat yourself
less.]

> The attached patch, against the jarkko-sgx/master branch of Jarkko's
> driver repository, provides a framework that implements
> cryptographically secure enclave initialization policies.  The patch
> and it's signature are also available from the following URL's:
>
> ftp://ftp.idfusion.net/pub/idfusion/jarkko-master-SFLC.patch

I just spend several minutes trying to read your code.  It would
benefit dramatically from some attempt at documentation, and, at the
very least, you can't have a function foo(type *ptr) that does
something almost completely different when ptr == NULL and when ptr !=
NULL.  For a concrete example, consider sgx_launch_control().  If you
pass NULL, then there's a vaguely credible argument that the function
does what the name suggests.  If you pass non-NULL, it doesn't.  The
result is bug-prone and unreadable.

If I'm understanding it right, it causes the SGX ABI to be almost
completely incompatible between the case where the list of launch
signers is empty and the case where the list is non-empty.  This is a
non-starter.  We're also extensively discussed how launch enclaves
would be supported if we were to support them, and the generally
agreed-upon solution was that the *kernel* would handle running a
launch enclave.  Jarkko even has code for this, but it's tabled until
someone comes up with a credible argument that we *want* to support
launch enclaves.

> The policy architecture allows just about any conceivable
> initialization policy to be implemented and in any combination.

No it doesn't, because it requires the application (or its runtime or
SDK or whatever) to bundle the launch enclave that implements the
fancy policy, which means that the platform owner actually can't swap
out the policy without breaking all the applications.  This is the
primary reason that, if Linux were to support LE-based launch control,
it would do so in the kernel.

> If the platform owner chooses to do nothing, the driver will
> initialize any enclave that is presented to it.  FWIW, we have close
> to a century of enterprise system's administration experience on our
> team and we could not envision any competent system's administrator,
> concerned about security, who would allow such a configuration.

A sufficiently careful administrator who wants to protect against
enclave malware might want the ability to revoke permission to run a
specific enclave, which your approach can't do.  Again, this has all
been covered extensively.

To be crystal clear, i fully agree that we are likely to eventually
want some kind of in-kernel launch policy.  But I don't think that
defining such a policy should block the upstreaming of the driver, and
I don't think that your proposal for how the policy should work is an
acceptable proposal.
