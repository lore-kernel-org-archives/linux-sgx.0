Return-Path: <SRS0=03YQ=C6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E158C4363C
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 19:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A48A216C4
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 19:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgIUT1S (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 21 Sep 2020 15:27:18 -0400
Received: from mga18.intel.com ([134.134.136.126]:17363 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbgIUT1R (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 21 Sep 2020 15:27:17 -0400
IronPort-SDR: CwUALfPyt1QqYCLPG3gx3+k6kQ2nJF+rAESGeG5C9excg3hY6VGFamGCZE3E3Wdupz6AjLK3B3
 E4cgmlDejXgA==
X-IronPort-AV: E=McAfee;i="6000,8403,9751"; a="148219672"
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="148219672"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 12:27:15 -0700
IronPort-SDR: cbyPBXm0cb5xQM9sQE62eDXqaA8R2a6gfDqOoDkAwymNNFzUkh45aE+8ekQNj6Q/n7bURhzaAA
 YZf7xt9VgpFA==
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="485633868"
Received: from tsenx-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.44.83])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 12:27:08 -0700
Date:   Mon, 21 Sep 2020 22:27:06 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Lutomirski <luto@kernel.org>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com
Subject: Re: [PATCH v38 15/24] x86/sgx: Enable provisioning for remote
 attestation
Message-ID: <20200921192706.GD53597@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-16-jarkko.sakkinen@linux.intel.com>
 <20200921180728.GJ5901@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921180728.GJ5901@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 21, 2020 at 08:07:28PM +0200, Borislav Petkov wrote:
> On Tue, Sep 15, 2020 at 02:28:33PM +0300, Jarkko Sakkinen wrote:
> > @@ -181,5 +192,12 @@ int __init sgx_drv_init(void)
> >  		return ret;
> >  	}
> >  
> > +	ret = misc_register(&sgx_dev_provision);
> > +	if (ret) {
> > +		pr_err("Creating /dev/sgx/provision failed with %d.\n", ret);
> > +		misc_deregister(&sgx_dev_enclave);
> 
> The comment over misc_deregister() says:
> 
>  *      Unregister a miscellaneous device that was previously
>  *      successfully registered with misc_register().
> 
> but this is not a successful registration here, in the if (ret) case...

'sgx_dev_enclave' is successfully register whenever that happens. Am I
missing something here?

> > + * sgx_ioc_enclave_set_attribute - handler for %SGX_IOC_ENCLAVE_PROVISION
> > + * @filep:	open file to /dev/sgx
>        ^^^^^^
> 
> Can you guess what my comment to that would be...?

There is also another incosistency that I fixed: the first line should
have 'sgx_ioc_enclave_provision'.

> > +static long sgx_ioc_enclave_provision(struct sgx_encl *encl,
> > +					  void __user *arg)
> 
> No need for the line break: both function args can fit on the same line.

Fixed this one too, thanks.

> 
> ...
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
