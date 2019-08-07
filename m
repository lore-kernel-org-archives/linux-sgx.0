Return-Path: <SRS0=l2ne=WD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 030C3C32751
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Aug 2019 15:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D508D21E73
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Aug 2019 15:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388144AbfHGPS4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Aug 2019 11:18:56 -0400
Received: from mga03.intel.com ([134.134.136.65]:64032 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387543AbfHGPS4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Aug 2019 11:18:56 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Aug 2019 08:15:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,357,1559545200"; 
   d="scan'208";a="198698514"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.189])
  by fmsmga004.fm.intel.com with ESMTP; 07 Aug 2019 08:15:33 -0700
Date:   Wed, 7 Aug 2019 18:15:34 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Ayoun, Serge" <serge.ayoun@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
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
Message-ID: <20190807151534.kxsletvhbn3lno6w@linux.intel.com>
References: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
 <20190713170804.2340-17-jarkko.sakkinen@linux.intel.com>
 <88B7642769729B409B4A93D7C5E0C5E7C65ABB8D@hasmsx108.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88B7642769729B409B4A93D7C5E0C5E7C65ABB8D@hasmsx108.ger.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jul 29, 2019 at 11:17:57AM +0000, Ayoun, Serge wrote:
> > +	/* TCS pages need to be RW in the PTEs, but can be 0 in the EPCM. */
> > +	if ((secinfo.flags & SGX_SECINFO_PAGE_TYPE_MASK) ==
> > SGX_SECINFO_TCS)
> > +		prot |= PROT_READ | PROT_WRITE;
> 
> For TCS pages you add both RD and WR maximum protection bits.
> For the enclave to be able to run, user mode will have to change the
> "vma->vm_flags" from PROT_NONE to PROT_READ | PROT_WRITE (otherwise
> eenter fails).  This is exactly what your selftest  does.

Recap where the TCS requirements came from? Why does it need
RW in PTEs and can be 0 in the EPCM? The comment should explain
it rather leave it as a claim IMHO.

/Jarkko
