Return-Path: <SRS0=GWrB=2I=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D77C5C43603
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Dec 2019 15:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA04E21582
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Dec 2019 15:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfLRPTq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Dec 2019 10:19:46 -0500
Received: from mga14.intel.com ([192.55.52.115]:3786 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbfLRPTq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Dec 2019 10:19:46 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 07:19:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="212949490"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 18 Dec 2019 07:19:44 -0800
Date:   Wed, 18 Dec 2019 07:19:44 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v24 08/24] x86/sgx: Enumerate and track EPC sections
Message-ID: <20191218151944.GA25201@linux.intel.com>
References: <20191129231326.18076-1-jarkko.sakkinen@linux.intel.com>
 <20191129231326.18076-9-jarkko.sakkinen@linux.intel.com>
 <20191218091856.GA24886@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218091856.GA24886@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 18, 2019 at 10:18:56AM +0100, Borislav Petkov wrote:
> On Sat, Nov 30, 2019 at 01:13:10AM +0200, Jarkko Sakkinen wrote:
> > +static bool __init sgx_alloc_epc_section(u64 addr, u64 size,
> > +					 unsigned long index,
> > +					 struct sgx_epc_section *section)
> > +{
> > +	unsigned long nr_pages = size >> PAGE_SHIFT;
> 
> I'm assuming here that size which gets communicated through CPUID -
> which is an interesting way to communicate SGX settings in itself :-) - is
> in multiples of 4K? SDM doesn't say...

Yes, EPC pages are architecturally defined to be 4k sized and aligned.

  36.5 Enclave Page Cache

  The EPC is divided into EPC pages. An EPC page is 4KB in size and always
  aligned on a 4KB boundary.
