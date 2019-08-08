Return-Path: <SRS0=scwG=WE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4DE5C0650F
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 15:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E120208C3
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 15:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732680AbfHHPkD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Aug 2019 11:40:03 -0400
Received: from mga07.intel.com ([134.134.136.100]:60338 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733256AbfHHPkD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Aug 2019 11:40:03 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Aug 2019 08:40:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,362,1559545200"; 
   d="scan'208";a="174881313"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 08 Aug 2019 08:40:00 -0700
Date:   Thu, 8 Aug 2019 08:40:00 -0700
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
Message-ID: <20190808154000.GB23156@linux.intel.com>
References: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
 <20190713170804.2340-17-jarkko.sakkinen@linux.intel.com>
 <88B7642769729B409B4A93D7C5E0C5E7C65ABB8D@hasmsx108.ger.corp.intel.com>
 <20190807151534.kxsletvhbn3lno6w@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807151534.kxsletvhbn3lno6w@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 07, 2019 at 06:15:34PM +0300, Jarkko Sakkinen wrote:
> On Mon, Jul 29, 2019 at 11:17:57AM +0000, Ayoun, Serge wrote:
> > > +	/* TCS pages need to be RW in the PTEs, but can be 0 in the EPCM. */
> > > +	if ((secinfo.flags & SGX_SECINFO_PAGE_TYPE_MASK) ==
> > > SGX_SECINFO_TCS)
> > > +		prot |= PROT_READ | PROT_WRITE;
> > 
> > For TCS pages you add both RD and WR maximum protection bits.
> > For the enclave to be able to run, user mode will have to change the
> > "vma->vm_flags" from PROT_NONE to PROT_READ | PROT_WRITE (otherwise
> > eenter fails).  This is exactly what your selftest  does.
> 
> Recap where the TCS requirements came from? Why does it need
> RW in PTEs and can be 0 in the EPCM? The comment should explain
> it rather leave it as a claim IMHO.

Hardware ignores SECINFO.FLAGS.{R,W,X} coming from userspace and instead
forces RWX=0.  It does this to prevent software from directly accessing
the TCS.  But hardware still accesses the TCS through a virtual address,
e.g. to allow software to zap the page for reclaim, which means hardware
generates reads and writes to the TCS, i.e. the PTEs need RW permissions.

So, for the EADD ioctl(), it's not unreasonable for userspace to provide
SECINFO.FLAGS.{R,W,X} = 0 for the TCS to match what will actually get
jammed into the EPCM.  Allowing userspace to specify RWX=0 means the
kernel needs to manually add PROT_READ and PROT_WRITE to the allowed prot
bits so that mmap()/mprotect() work as expected.

From the SDM:


(* For TCS pages, force EPCM.rwx bits to 0 and no debug access *)
IF (SCRATCH_SECINFO.FLAGS.PT = PT_TCS)
    THEN
        SCRATCH_SECINFO.FLAGS.R <= 0;
        SCRATCH_SECINFO.FLAGS.W <= 0;
        SCRATCH_SECINFO.FLAGS.X <= 0;
        (DS:RCX).FLAGS.DBGOPTIN <= 0; // force TCS.FLAGS.DBGOPTIN off
        DS:RCX.CSSA <= 0;
        DS:RCX.AEP <= 0;
        DS:RCX.STATE <= 0;
        FI;
