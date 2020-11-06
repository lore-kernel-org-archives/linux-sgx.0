Return-Path: <SRS0=0h1F=EM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5120DC2D0A3
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Nov 2020 17:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF980217A0
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Nov 2020 17:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgKFRow (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 6 Nov 2020 12:44:52 -0500
Received: from wind.enjellic.com ([76.10.64.91]:59792 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726034AbgKFRow (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 6 Nov 2020 12:44:52 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 0A6Hi0HP024602;
        Fri, 6 Nov 2020 11:44:00 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 0A6HhxkZ024601;
        Fri, 6 Nov 2020 11:43:59 -0600
Date:   Fri, 6 Nov 2020 11:43:59 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v40 10/24] mm: Add 'mprotect' hook to struct vm_operations_struct
Message-ID: <20201106174359.GA24109@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com> <20201104145430.300542-11-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104145430.300542-11-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Fri, 06 Nov 2020 11:44:00 -0600 (CST)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Nov 04, 2020 at 04:54:16PM +0200, Jarkko Sakkinen wrote:

Good morning, I hope the week has gone well for everyone.

> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Background
> ==========
> 
> 1. SGX enclave pages are populated with data by copying from normal memory
>    via ioctl() (SGX_IOC_ENCLAVE_ADD_PAGES), which will be added later in
>    this series.
> 2. It is desirable to be able to restrict those normal memory data sources.
>    For instance, to ensure that the source data is executable before
>    copying data to an executable enclave page.
> 3. Enclave page permissions are dynamic (just like normal permissions) and
>    can be adjusted at runtime with mprotect().

Only relevant on SGX2 hardware, see discussion below.

> This creates a problem because the original data source may have
> long since vanished at the time when enclave page permissions are
> established (mmap() or mprotect()).
>
> The solution (elsewhere in this series) is to force enclaves

I don't believe that enclaves should be plural in this context.

> creators to declare their paging permission *intent* up front to the
> ioctl().  This intent can me immediately compared to the source

The 'me' should be 'be' in the above line.

> data???s mapping and rejected if necessary.
>
> The ???intent??? is also stashed off for later comparison with
> enclave PTEs. This ensures that any future mmap()/mprotect()
> operations performed by the enclave creator or done on behalf of the
> enclave can be compared with the earlier declared permissions.

Just some further clarifications that should, arguably, be included in
the kernel documentation given their security implications.

The 900 pound primate in the room, that no one is acknowledging, is
that this technology was designed to not allow the operating system to
have any control over what it is doing.  In the mindset of kernel
developers, the operating system is the absolute authority on
security, so we find ourselves in a situation where the kernel needs
to try and work around this fact so any solutions will be imperfect at
best.

As I've noted before, this is actually a primary objective of enclave
authors, since one of the desires for 'Confidential Computing' is to
hide things like proprietary algorithms from the platform owners.  I
think the driver needs to acknowledge this fact and equip platform
owners with the simplest and most effective security solutions that
are available.

The only reason that mprotect protections are needed in this driver
are to close a security loophole on SGX2 hardware, ie. hardware that
supports the ENCLU[EMODPE] instruction.  This instruction allows an
enclave to modify page permissions that are encoded in the Enclave
Page Cache Metadata (EPCM) at initialization time.  In all likelihood,
this is going to be the only relevant hardware that this driver runs
on.

On SGX2 hardware, enclave based code can conspire with its untrusted
runtime to allow executable regions to have write permissions.  This
would allow the enclave to load and execute whatever code that it
pleases and that the operating system would have no visibility into
whatsoever.

The non-SGX2 platforms don't need mprotect protections since even if
they were to modify at the OS level their page permissions, any
attempts to access a page with modified permissions would be trapped
by the EPCM protections that are unmodifiable after the enclave has
been initialized.

In light of this, given the decision by the driver authors to not
fully equip the driver with EDMM support, the mprotect protection
requirements are straight forward and minimalistic.  All that is
needed is a binary valued variable, set on the command-line, that
either allows or denies anonymous code execution by an enclave,
ie. access to page protection changes after initialization.

The enclave page mapping callback is elegant but has little use if the
objective of all this is to allow the driver to enforce SGX1 semantics
on a platform that has SGX2 instruction support.  Save the elegant
solution until a reasoned arguement can be made as to what anyone
would actually be able to do with the per page permissions checks,
even on an EDMM capable driver.

I could go into detail on that issue as well but I hesitate to be an
insufferable bore.

I hope all of this is helpful.

Have a good weekend.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker      Autonomously self-defensive
Enjellic Systems Development, LLC     IOT platforms and edge devices.
4206 N. 19th Ave.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"In the future, company names will be a 32-character hex string."
                                -- Bruce Schneier
