Return-Path: <SRS0=KK61=O3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA77C43387
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Dec 2018 05:02:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A46E52133F
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Dec 2018 05:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545109337;
	bh=TKC+IXVMQgdMwlbJGDewPI6zoy8Su+7mMv0Fg9t32oE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=vn0TzYKfq0HjhqA1kdcxa5DfiHY3p7JRDR09R095W4cdsmaGRVLrE64SqgvoyE6Tg
	 U6wlj6S/BtN6/3MGj1owqko17Csxds1nIVxLZWq26ErSphp4TB2gYthD471wMVoCYd
	 2vVhPJRZ2Ny3sPAncBOugjWXrSouL1uB1GJ0cJMc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbeLRFCR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Dec 2018 00:02:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:43166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbeLRFCR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Dec 2018 00:02:17 -0500
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CCC8218A1
        for <linux-sgx@vger.kernel.org>; Tue, 18 Dec 2018 05:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545109336;
        bh=TKC+IXVMQgdMwlbJGDewPI6zoy8Su+7mMv0Fg9t32oE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GIpfKf8KJLjGF+YHMjLREb3Jreqz0PwGIEoA1KoN2ISRYXLm4Dwu0lQmJT5hfc20c
         qAmp12tquW3iLsFMXFG7n+5G5AnvZ6pviLqHI9zb59Rz/pzR6HtvlibGUvOYW7BhG6
         4ZkYs0q+H0Tbw+xRfJAhJeqL0M6LcLG3iO+OvWVw=
Received: by mail-wr1-f43.google.com with SMTP id x10so14485309wrs.8
        for <linux-sgx@vger.kernel.org>; Mon, 17 Dec 2018 21:02:16 -0800 (PST)
X-Gm-Message-State: AA+aEWZ+xm8jLNMct/eq8qgc5jQwCC/7OE+fdYdpMpuC82zB/AFDFid+
        Y06hq0wnRfafFzAPjF4nLEHcPF8UoUSC39/V3ujEOA==
X-Google-Smtp-Source: AFSGD/XUbvei4YCn+C8ifzCzpXPA6k6601K/QUQXaeTuRkksI/PXPFnqioCqali11te8+fOTMEgUpI6hgt6q7DBK06A=
X-Received: by 2002:a5d:550f:: with SMTP id b15mr13723383wrv.330.1545109334432;
 Mon, 17 Dec 2018 21:02:14 -0800 (PST)
MIME-Version: 1.0
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com> <7d5cde02-4649-546b-0f03-2d6414bb80b5@intel.com>
 <20181217180102.GA12560@linux.intel.com> <20181217183613.GD12491@linux.intel.com>
 <20181217184333.GA26920@linux.intel.com> <ccfb67a0-fd8d-82c8-8018-fd68e901f287@intel.com>
 <CALCETrX0W4dhFJBHEbDbKed_QZxmw6ZNMajfsoVgqGqhMB0nDg@mail.gmail.com>
 <20181217222047.GG12491@linux.intel.com> <20181218013918.GC333@linux.intel.com>
 <20181218032702.GA2903@linux.intel.com>
In-Reply-To: <20181218032702.GA2903@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 17 Dec 2018 21:02:03 -0800
X-Gmail-Original-Message-ID: <CALCETrVTfGUSfm5hy9_F00LcMUHJqAjOmfJhtXP+uD5dnmt4EQ@mail.gmail.com>
Message-ID: <CALCETrVTfGUSfm5hy9_F00LcMUHJqAjOmfJhtXP+uD5dnmt4EQ@mail.gmail.com>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>, X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        shay.katz-zamir@intel.com,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
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

On Mon, Dec 17, 2018 at 7:27 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Tue, Dec 18, 2018 at 03:39:18AM +0200, Jarkko Sakkinen wrote:
> > On Mon, Dec 17, 2018 at 02:20:48PM -0800, Sean Christopherson wrote:
> > > The only potential hiccup I can see is the build flow.  Currently,
> > > EADD+EEXTEND is done via a work queue to avoid major performance issues
> > > (10x regression) when userspace is building multiple enclaves in parallel
> > > using goroutines to wrap Cgo (the issue might apply to any M:N scheduler,
> > > but I've only confirmed the Golang case).  The issue is that allocating
> > > an EPC page acts like a blocking syscall when the EPC is under pressure,
> > > i.e. an EPC page isn't immediately available.  This causes Go's scheduler
> > > to thrash and tank performance[1].
> >
> > I don't see any major issues having that kthread. All the code that
> > maps the enclave would be removed.
> >
> > I would only allow to map enclave to process address space after the
> > enclave has been initialized i.e. SGX_IOC_ENCLAVE_ATTACH.
>
> Some refined thoughts.
>
> PTE insertion can done in the #PF handler. In fact, we can PoC this
> already with the current architecture (and I will right after sending
> v18).
>
> The backing space is a bit more nasty issue in the add pager thread.
> The previous shmem swapping would have been a better fit. Maybe that
> should be reconsidered?
>
> If shmem was used, all the commits up to "SGX Enclave Driver" could
> be reworked to the new model.
>
> When we think about the swapping code, there uprises some difficulties.
> Namely, when a page is swapped, the enclave must unmap the PTE from all
> processes that have it mapped.

That's what unmap_mapping_range(), etc do for you, no?  IOW make a
struct address_space that represents the logical enclave address
space, i.e. address 0 is the start and the pages count up from there.
You can unmap pages whenever you want, and the core mm code will take
care of zapping the pages from all vmas referencing that
address_space.
