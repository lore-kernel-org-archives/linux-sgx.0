Return-Path: <SRS0=GMJ6=D6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 717ADC388F9
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Oct 2020 09:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1616521D43
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Oct 2020 09:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460985AbgJWJDW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Oct 2020 05:03:22 -0400
Received: from mga05.intel.com ([192.55.52.43]:52491 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S460906AbgJWJDW (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Oct 2020 05:03:22 -0400
IronPort-SDR: 1pYa2J2h8iXQKIRgCSK7rjuwRvXup+AB2YxkJxjYiHR146xOablPEgkj2eGqq0wzg7Af8lOanq
 eo8mhPZirDSw==
X-IronPort-AV: E=McAfee;i="6000,8403,9782"; a="252346678"
X-IronPort-AV: E=Sophos;i="5.77,407,1596524400"; 
   d="scan'208";a="252346678"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 02:03:14 -0700
IronPort-SDR: Ncx9ht++ornms4l9FHuaFAcqsd4HIiulbAn0UbVs8ikhdUcMEz3NuTafWw7ZebG94yI5SwyUmp
 8D6eJa0Vu0KA==
X-IronPort-AV: E=Sophos;i="5.77,407,1596524400"; 
   d="scan'208";a="302612344"
Received: from spiccard-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.41.38])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 02:03:02 -0700
Date:   Fri, 23 Oct 2020 12:03:01 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Serge Ayoun <serge.ayoun@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        haitao.huang@intel.com, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v39 08/24] x86/sgx: Initialize metadata for Enclave Page
 Cache (EPC) sections
Message-ID: <20201023090301.GB168477@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-9-jarkko.sakkinen@linux.intel.com>
 <20201019084558.GA1155569@kapsi.fi>
 <271c12d9-1a01-b7f4-82c1-b0ce8f86b2b7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <271c12d9-1a01-b7f4-82c1-b0ce8f86b2b7@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 19, 2020 at 06:40:34AM -0700, Dave Hansen wrote:
> On 10/19/20 1:45 AM, Jarkko Sakkinen wrote:
> > On Sat, Oct 03, 2020 at 07:50:43AM +0300, Jarkko Sakkinen wrote:
> >> +config INTEL_SGX
> > Since the directory for this was renamed some iterations ago from
> > arch/x86/kernel/cpu/sgx to intel_sgx given the feedback from Boris,
> > I'm wondering should this also be renamed as X86_SGX?
> 
> I say yes for two reasons:
> 
> We're recently adding a prohibition against vendors adding
> VENDOR_FEATURE, preferring "FEATURE" instead.  But, I seriously doubt
> anyone else is going to to to the effort that Intel did here.
> 
> Also "SGX" is short enough that I can imagine someone else plausibly
> wanting to do CONFIG_SGX for something else.
> 
> So, I'm OK with keeping "INTEL_SGX", but I'd also be fine with "X86_SGX".

I'll rename it to X86_SGX, given that we changed the directory earlier
(based on feedback) from "intel_sgx" to "sgx".

/Jarkko
