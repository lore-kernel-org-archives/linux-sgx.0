Return-Path: <SRS0=W5EA=EK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4084FC2D0A3
	for <linux-sgx@archiver.kernel.org>; Wed,  4 Nov 2020 19:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2C46206D9
	for <linux-sgx@archiver.kernel.org>; Wed,  4 Nov 2020 19:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604516954;
	bh=mSutlcNYIah1MmEz6WNyZ34UpZyeTVM1cMbko4T6UI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=j8IpNPc8gXCUwrkgmdDkPIe6WSZTUQUDSl+fak5QLeLvvVsgFhlL3Cnh2NaSeNsJl
	 jMQ46cvLmN5Il/orggwf3F8FxHYDHcKzkORPc2nTvCadrafOrPkbqGTRbJlhcNzShp
	 X7MYfKqPJFFZGsmEOZVz/WbV2K3RWj+8CNtQ+XSI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbgKDTJO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 4 Nov 2020 14:09:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:38622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729723AbgKDTJO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 4 Nov 2020 14:09:14 -0500
Received: from kernel.org (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56636206B7;
        Wed,  4 Nov 2020 19:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604516953;
        bh=mSutlcNYIah1MmEz6WNyZ34UpZyeTVM1cMbko4T6UI8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DMtlPfalLECP8WrKkuG7GIUjuAVmeLg4GcMSxrxBflnQzN9202rpCQy8PrhB4jNMm
         kyjLDs7T2OrCFeiI1Vop/WGLAoP2SfroJPDKm/5F8ShozN6GXgkXkZebsqBOPiu97+
         snzA0449+/x+ojGI0EOgPMq1GTgpHXcEVko/G3tw=
Date:   Wed, 4 Nov 2020 21:09:03 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Serge Ayoun <serge.ayoun@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v40 03/24] x86/sgx: Initialize metadata for Enclave Page
 Cache (EPC) sections
Message-ID: <20201104190903.GA304537@kernel.org>
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com>
 <20201104145430.300542-4-jarkko.sakkinen@linux.intel.com>
 <20201104182129.GD23298@zn.tnic>
 <20201104190443.GA318315@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104190443.GA318315@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Nov 04, 2020 at 09:04:52PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 04, 2020 at 07:21:29PM +0100, Borislav Petkov wrote:
> > On Wed, Nov 04, 2020 at 04:54:09PM +0200, Jarkko Sakkinen wrote:
> > > +static void __init sgx_init(void)
> > > +{
> > > +	int i;
> > > +
> > > +	if (!boot_cpu_has(X86_FEATURE_SGX))
> > 
> > Guys, you need to build-test *every* *single* patch - otherwise we break
> > bisectability and that is a no-no:
> 
> I've done it quite a few times (every time I've rebased my tree).  I did
> today too before sending but forgot to redo git format-patch again (was
> the very last thing). In my tree the order is:

If you want, I can do a resend of this version same time underlining
that this the only difference and I do have a framework to check this
thing in place.

> e987eb0c95dd (HEAD -> master, origin/master, origin/HEAD) x86/sgx: Update MAINTAINERS
> 90dc0ee37f44 docs: x86/sgx: Document SGX kernel architecture
> 1c2e9bdab128 x86/sgx: Add ptrace() support for the SGX driver
> 05ce4345fb5f x86/sgx: Add a page reclaimer
> 94c1f778fa09 selftests/x86: Add a selftest for SGX
> 741b631d197b x86/vdso: Implement a vDSO for Intel SGX enclave call
> 5744b02641ff x86/traps: Attempt to fixup exceptions in vDSO before signaling
> e957c7e79dd0 x86/fault: Add helper function to sanitize error code
> 96cc520b2bc9 x86/vdso: Add support for exception fixup in vDSO functions
> 4aff9d81b2fe x86/sgx: Add SGX_IOC_ENCLAVE_PROVISION
> ea9bc917c469 x86/sgx: Add SGX_IOC_ENCLAVE_INIT
> 6e61e843291d x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES
> 4235ce22235e x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
> 681299401c91 x86/sgx: Add SGX misc driver interface
> fbd69fd9acf4 mm: Add 'mprotect' hook to struct vm_operations_struct
> 93b27a8908aa x86/sgx: Add SGX page allocator functions
> 5984a2ca130c x86/cpu/intel: Add nosgx kernel parameter
> e131efe5ba06 x86/cpu/intel: Detect SGX support
> b0bacb54d36c x86/mm: x86/sgx: Signal SIGSEGV with PF_SGX
> 0c64b4c07298 x86/sgx: Initialize metadata for Enclave Page Cache (EPC) sections
> 358d17098c4c x86/cpufeatures: x86/msr: Add Intel SGX Launch Control hardware bits
> 8f7ab60e5458 x86/cpufeatures: x86/msr: Add Intel SGX hardware bits
> 0fb18ca935cf x86/sgx: Add wrappers for ENCLS functions
> 3dbc95582baf x86/sgx: Add SGX architectural data structures
> 
> I always do this before I send the patch set (or rebase my tree):
> 
> for x in {23..0}
> do
> git checkout master~$x
> git clean -f -d -x
> make tinyconfig && cat >> .config <<EOF
> CONFIG_64BIT=y   
> CONFIG_CRYPTO=y
> CONFIG_CRYPTO_SHA256=y
> CONFIG_X86_SGX=y
> CONFIG_DEBUG_INFO=y
> EOF
> yes '' | make oldconfig && make CC="ccache gcc" -j$(nproc) || break
> git --no-pager log --oneline -1 >> success.txt
> done
> 
> The order is the only difference between the patch set and my tree (i.e.
> diff's do not conflict between the orderings).

/Jarkko
