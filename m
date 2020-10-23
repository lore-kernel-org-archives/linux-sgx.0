Return-Path: <SRS0=GMJ6=D6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9FCDC55178
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Oct 2020 10:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 894BD24182
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Oct 2020 10:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S461952AbgJWKO0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Oct 2020 06:14:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:41359 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S461906AbgJWKO0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Oct 2020 06:14:26 -0400
IronPort-SDR: zf8lCfXOSOburnJRLQ1IA11cbqAKffmO9pTxcaFfag81YGszskYOi5O8fdI8cQVrBeQ4djGy/6
 k/QLdpcWm35A==
X-IronPort-AV: E=McAfee;i="6000,8403,9782"; a="167776701"
X-IronPort-AV: E=Sophos;i="5.77,407,1596524400"; 
   d="scan'208";a="167776701"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 03:14:21 -0700
IronPort-SDR: k2nXBRs3QZ/XH/H9tsrKtVoFHbmFvvLaTJOUIBX3JQUhqZzb+Y4WMU1JEup+QY7ajzeCGuF+Ay
 1DbaPSHJ13Uw==
X-IronPort-AV: E=Sophos;i="5.77,407,1596524400"; 
   d="scan'208";a="302628827"
Received: from spiccard-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.41.38])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 03:14:08 -0700
Date:   Fri, 23 Oct 2020 13:14:08 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Lutomirski <luto@kernel.org>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        haitao.huang@intel.com, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v39 15/24] x86/sgx: Add SGX_IOC_ENCLAVE_PROVISION
Message-ID: <20201023101408.GF168477@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-16-jarkko.sakkinen@linux.intel.com>
 <91637b13-c0ee-82bd-05cd-5ce848004eae@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91637b13-c0ee-82bd-05cd-5ce848004eae@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Oct 20, 2020 at 08:48:54AM -0700, Dave Hansen wrote:
> >  int __init sgx_drv_init(void)
> >  {
> >  	unsigned int eax, ebx, ecx, edx;
> > @@ -181,5 +192,12 @@ int __init sgx_drv_init(void)
> >  		return ret;
> >  	}
> >  
> > +	ret = misc_register(&sgx_dev_provision);
> > +	if (ret) {
> > +		pr_err("Creating /dev/sgx/provision failed with %d.\n", ret);
> > +		misc_deregister(&sgx_dev_enclave);
> > +		return ret;
> > +	}
> > +
> 
> Isn't it a *bit* too specific to say that a device file failed to be
> created?  Do other misc devices use this kind of message?

Before seeing this I had already removed it. It is incosistent at
least and quite useless error really. We have tracing tools for
this.

/Jarkko
