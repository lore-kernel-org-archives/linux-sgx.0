Return-Path: <SRS0=pIwf=6N=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC12C83003
	for <linux-sgx@archiver.kernel.org>; Wed, 29 Apr 2020 05:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4170920775
	for <linux-sgx@archiver.kernel.org>; Wed, 29 Apr 2020 05:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgD2FWH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 29 Apr 2020 01:22:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:35698 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgD2FWH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 29 Apr 2020 01:22:07 -0400
IronPort-SDR: vOfEp/qvbVQYMvsWgX57RZ8HTXA8sKwyTleD35A6Mclk77fa25dnmin6uVnoiLUWIJ9YTru019
 9idoxYFz5sWQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2020 22:22:07 -0700
IronPort-SDR: gApEQibzfaWPDLLuu0cQmFa2P4F9qrO05ILIahNqyZm6ZSvHd7pSIuRacfF5MjNF+/IozFM63g
 tsoTSESHjjOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,330,1583222400"; 
   d="scan'208";a="246735181"
Received: from ramibuso-mobl.ger.corp.intel.com (HELO localhost) ([10.249.47.170])
  by orsmga007.jf.intel.com with ESMTP; 28 Apr 2020 22:21:59 -0700
Date:   Wed, 29 Apr 2020 08:22:01 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Connor Kuehl <ckuehl@redhat.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
Message-ID: <20200429052201.GC8452@linux.intel.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
 <72e8fd3e-5d35-669c-3186-43754333fceb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72e8fd3e-5d35-669c-3186-43754333fceb@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Apr 22, 2020 at 09:48:58AM -0700, Connor Kuehl wrote:
> On 4/21/20 2:52 PM, Jarkko Sakkinen wrote:
> > v29:
> > * The selftest has been moved to selftests/sgx. Because SGX is an execution
> >    environment of its own, it really isn't a great fit with more "standard"
> >    x86 tests.
> > 
> >    The RSA key is now generated on fly and the whole signing process has
> >    been made as part of the enclave loader instead of signing the enclave
> >    during the compilation time.
> > 
> >    Finally, the enclave loader loads now the test enclave directly from its
> >    ELF file, which means that ELF file does not need to be coverted as raw
> >    binary during the build process.
> > * Version the mm_list instead of using on synchronize_mm() when adding new
> >    entries. We hold the write lock for the mm_struct, and dup_mm() can thus
> >    deadlock with the page reclaimer, which could hold the lock for the old
> >    mm_struct.
> > * Disallow mmap(PROT_NONE) from /dev/sgx. Any mapping (e.g. anonymous) can
> >    be used to reserve the address range. Now /dev/sgx supports only opaque
> >    mappings to the (initialized) enclave data.
> > * Make the vDSO callable directly from C by preserving RBX and taking leaf
> >    from RCX.
> 
> Hi all,
> 
> I've been producing Fedora 32 kernel builds with the SGX patches applied for
> a few of weeks and I've just produced a build with this latest revision[1].
> We've been using these kernels to enable SGX for some of our
> development/test machines.

Thanks a lot!

/Jarkko
