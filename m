Return-Path: <SRS0=yHMC=WF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC715C433FF
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Aug 2019 15:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E23E20B7C
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Aug 2019 15:24:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406607AbfHIPYG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 9 Aug 2019 11:24:06 -0400
Received: from mga12.intel.com ([192.55.52.136]:13199 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbfHIPYF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 9 Aug 2019 11:24:05 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Aug 2019 08:24:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,364,1559545200"; 
   d="scan'208";a="180166412"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 09 Aug 2019 08:24:04 -0700
Date:   Fri, 9 Aug 2019 08:24:04 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     "Ayoun, Serge" <serge.ayoun@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "Xing, Cedric" <cedric.xing@intel.com>
Subject: Re: [PATCH v21 16/28] x86/sgx: Add the Linux SGX Enclave Driver
Message-ID: <20190809152403.GA10541@linux.intel.com>
References: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
 <20190713170804.2340-17-jarkko.sakkinen@linux.intel.com>
 <88B7642769729B409B4A93D7C5E0C5E7C65ABB8D@hasmsx108.ger.corp.intel.com>
 <20190807151534.kxsletvhbn3lno6w@linux.intel.com>
 <20190808154000.GB23156@linux.intel.com>
 <cb8a7d13a31588205d1c18521e58a0ee4bac03f8.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb8a7d13a31588205d1c18521e58a0ee4bac03f8.camel@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Aug 09, 2019 at 06:02:08PM +0300, Jarkko Sakkinen wrote:
> On Thu, 2019-08-08 at 08:40 -0700, Sean Christopherson wrote:
> > On Wed, Aug 07, 2019 at 06:15:34PM +0300, Jarkko Sakkinen wrote:
> > > On Mon, Jul 29, 2019 at 11:17:57AM +0000, Ayoun, Serge wrote:
> > > > > +	/* TCS pages need to be RW in the PTEs, but can be 0 in the EPCM. */
> > > > > +	if ((secinfo.flags & SGX_SECINFO_PAGE_TYPE_MASK) ==
> > > > > SGX_SECINFO_TCS)
> > > > > +		prot |= PROT_READ | PROT_WRITE;
> > > > 
> > > > For TCS pages you add both RD and WR maximum protection bits.
> > > > For the enclave to be able to run, user mode will have to change the
> > > > "vma->vm_flags" from PROT_NONE to PROT_READ | PROT_WRITE (otherwise
> > > > eenter fails).  This is exactly what your selftest  does.
> > > 
> > > Recap where the TCS requirements came from? Why does it need
> > > RW in PTEs and can be 0 in the EPCM? The comment should explain
> > > it rather leave it as a claim IMHO.
> > 
> > Hardware ignores SECINFO.FLAGS.{R,W,X} coming from userspace and instead
> > forces RWX=0.  It does this to prevent software from directly accessing
> > the TCS.  But hardware still accesses the TCS through a virtual address,
> > e.g. to allow software to zap the page for reclaim, which means hardware
> > generates reads and writes to the TCS, i.e. the PTEs need RW permissions.
> 
> Manipulating a PTE should not require any specific permissions on the
> page that it is defining. Why RW is required in SGX context?

By PTEs I meant the TCS needs to be mapped RW in the kernel's page tables,
e.g. hardware generates read and write accesses to the TCS when entering
an enclave.

> > So, for the EADD ioctl(), it's not unreasonable for userspace to provide
> > SECINFO.FLAGS.{R,W,X} = 0 for the TCS to match what will actually get
> > jammed into the EPCM.  Allowing userspace to specify RWX=0 means the
> > kernel needs to manually add PROT_READ and PROT_WRITE to the allowed prot
> > bits so that mmap()/mprotect() work as expected.
> 
> Anyway, appreciate your throughtout explanation, thanks.
> 
> /Jarkko
> 
