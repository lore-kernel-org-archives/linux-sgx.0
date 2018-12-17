Return-Path: <SRS0=zBz/=O2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14BD5C43387
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 19:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D62D221783
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 19:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545073957;
	bh=G9zX9KVe7E5PaZcyj8gw8Uifhsyto9qYhWoeYUwDfiM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=OAg4grvyHw35jF3xTl+xVqAWHOSwUSDSLc6g47Jl8Fi+YqHANooOB9Omo46nNWt6c
	 bXx39ZjM1lHoVNAxBRLPopsgqMRlS5mIhBCS2DP0AUsHWFlMV7tKtQ25T2It3fVhc5
	 JTkwx1F5EjwTGvJEXt21GVu2EWHW19yzhpSdhsOA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387567AbeLQTMh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Dec 2018 14:12:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387451AbeLQTMh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Dec 2018 14:12:37 -0500
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E2812133F
        for <linux-sgx@vger.kernel.org>; Mon, 17 Dec 2018 19:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545073955;
        bh=G9zX9KVe7E5PaZcyj8gw8Uifhsyto9qYhWoeYUwDfiM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dAhL8Mr4gHkbig22LpMkQxUNn0jDzdA6yLtLjl0rkuIeFGj8N4OUGYgAfQKUecsGB
         6a3Kiv1i6jhes8QEKcod71SgJY9BEfKVO9iiksFi37yNPy6wU3mdbII0nIY7cGwXbd
         NH05CjshaTjm2BPgcgHVpGkSkl8369tTpC3ZvQ1E=
Received: by mail-wm1-f46.google.com with SMTP id f81so332552wmd.4
        for <linux-sgx@vger.kernel.org>; Mon, 17 Dec 2018 11:12:35 -0800 (PST)
X-Gm-Message-State: AA+aEWZK7yEJC4XXg8sRdB4k4MndtWn0TTwbfs00KoLJTwB5JQQzyWs0
        gPsoBDGS72hBPLygvkCWLv1GwTpRCLPLCLuYTIdFUQ==
X-Google-Smtp-Source: AFSGD/U5g9xnLjCya9cpU+KP5hL75xgfRFi66+5/uUZ4zJBgrcdDJZBJzu/nDcgMO2uNQbS6HLS3EgvhhneFToADDPI=
X-Received: by 2002:a1c:f112:: with SMTP id p18mr289692wmh.83.1545073954108;
 Mon, 17 Dec 2018 11:12:34 -0800 (PST)
MIME-Version: 1.0
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com> <7d5cde02-4649-546b-0f03-2d6414bb80b5@intel.com>
 <20181217180102.GA12560@linux.intel.com> <20181217183613.GD12491@linux.intel.com>
 <20181217184333.GA26920@linux.intel.com> <ccfb67a0-fd8d-82c8-8018-fd68e901f287@intel.com>
In-Reply-To: <ccfb67a0-fd8d-82c8-8018-fd68e901f287@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 17 Dec 2018 11:12:21 -0800
X-Gmail-Original-Message-ID: <CALCETrX0W4dhFJBHEbDbKed_QZxmw6ZNMajfsoVgqGqhMB0nDg@mail.gmail.com>
Message-ID: <CALCETrX0W4dhFJBHEbDbKed_QZxmw6ZNMajfsoVgqGqhMB0nDg@mail.gmail.com>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        shay.katz-zamir@intel.com,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 17, 2018 at 10:47 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 12/17/18 10:43 AM, Jarkko Sakkinen wrote:
> > On Mon, Dec 17, 2018 at 10:36:13AM -0800, Sean Christopherson wrote:
> >> I'm pretty sure doing mmget() would result in circular dependencies and
> >> a zombie enclave.  In the do_exit() case where a task is abruptly killed:
> >>
> >>   - __mmput() is never called because the enclave holds a ref
> >>   - sgx_encl_release() is never be called because its VMAs hold refs
> >>   - sgx_vma_close() is never called because __mmput()->exit_mmap() is
> >>     blocked and the process itself is dead, i.e. won't unmap anything.
> > Right, it does, you are absolutely right. Tried it and removed the
> > commit already.
> >
> > Well, what we came up from your suggestion i.e. setting mm to NULL
> > and checking that is very subtle change and does not have any such
> > circular dependencies. We'll go with that.
>
> This all screams that you need to break out this code from the massive
> "18" patch and get the mm interactions reviewed more thoroughly.
>
> Also, no matter what method you go with, you have a bunch of commenting
> and changelogging to do here.

I'm going to ask an obnoxious high-level question: why does an enclave
even refer to a specific mm?

If I were designing this thing, and if I hadn't started trying to
implement it, my first thought would be that an enclave tracks its
linear address range, which is just a pair of numbers, and also keeps
track of a whole bunch of physical EPC pages, data structures, etc.
And that mmap() gets rejected unless the requested virtual address
matches the linear address range that the enclave wants and, aside
from that, just creates a VMA that keeps a reference to the enclave.
(And, for convenience, I suppose that the first mmap() call done
before any actual enclave setup happens could choose any address and
then cause the enclave to lock itself to that address, although a
regular anonymous PROT_NONE MAP_NORESERVE mapping would do just fine,
too.)  And the driver would explicitly allow multiple different mms to
have the same enclave mapped.  More importantly, a daemon could set up
an enclave without necessarily mapping it at all and then SCM_RIGHTS
the enclave over to the process that plans to run it.

Now I'm sure this has all kinds of problems, such as the ISA possibly
making it rather obnoxious to add pages to the enclave without having
it mapped.  But these operations could, in principle, be done by
having the enclave own a private mm that's used just for setup.  While
this would be vaguely annoying, Nadav's still-pending-but-nearly-done
text_poke series adds all the infrastructure that's needed for the
kernel to manage little private mms.  But some things get simpler --
invalidating the enclave can presumably use the regular rmap APIs to
zap all the PTEs in all VMAs pointing into the enclave.

So I'm not saying that you shouldn't do it the way you are now, but I
do think that the changelog or at least some emails should explain
*why* the enclave needs to keep a pointer to the creating process's
mm.  And, if you do keep the current model, it would be nice to
understand what happens if you do something awful like mremap()ing an
enclave, or calling madvise on it, or otherwise abusing the vma.  Or
doing fork(), for that matter.

I also find it suspicious that the various ioctl handlers
systematically ignore their "filep" parameters and instead use
find_vma() to find the relevant mm data structures.  That seems
backwards.
