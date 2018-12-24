Return-Path: <SRS0=n9z9=PB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9657C43387
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Dec 2018 11:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B08CB2184C
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Dec 2018 11:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbeLXL6D (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 24 Dec 2018 06:58:03 -0500
Received: from mga07.intel.com ([134.134.136.100]:31096 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbeLXL6D (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 24 Dec 2018 06:58:03 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Dec 2018 03:58:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,392,1539673200"; 
   d="scan'208";a="121344355"
Received: from dlu2-mobl4.ccr.corp.intel.com (HELO localhost) ([10.249.254.240])
  by orsmga001.jf.intel.com with ESMTP; 24 Dec 2018 03:57:56 -0800
Date:   Mon, 24 Dec 2018 13:57:55 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "haitao.huang@intel.com" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kai.svahn@intel.com" <kai.svahn@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "luto@kernel.org" <luto@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v18 19/25] x86/sgx: Add provisioning
Message-ID: <20181224115755.GD10971@linux.intel.com>
References: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
 <20181221231154.6120-20-jarkko.sakkinen@linux.intel.com>
 <f5b6cd98-99f1-fa21-041a-829026b51265@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5b6cd98-99f1-fa21-041a-829026b51265@fortanix.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 24, 2018 at 05:36:36AM +0000, Jethro Beekman wrote:
> On 2018-12-22 04:41, Jarkko Sakkinen wrote:
> > In order to provide a mechanism for devilering provisoning rights:
> > 
> > 1. Add a new file to the securityfs file called sgx/provision that works
> >     as a token for allowing an enclave to have the provisioning privileges.
> > 2. Add a new ioctl called SGX_IOC_ENCLAVE_SET_ATTRIBUTE that accepts the
> >     following data structure:
> > 
> >     struct sgx_enclave_set_attribute {
> >             __u64 addr;
> >             __u64 token_fd;
> >     };
> > 
> > A daemon could sit on top of sgx/provision and send a file descriptor of
> > this file to a process that needs to be able to provision enclaves.
> > 
> > The way this API is used is more or less straight-forward. Lets assume that
> > dev_fd is a handle to /dev/sgx and prov_fd is a handle to sgx/provision.
> > You would allow SGX_IOC_ENCLAVE_CREATE to initialize an enclave with the
> > PROVISIONKEY attribute by
> > 
> > params.addr = <enclave address>;
> > params.token_fd = prov_fd;
> > 
> > ioctl(dev_fd, SGX_IOC_ENCLAVE_SET_ATTRIBUTE, &params);
> 
> I think the attribute handling in this and the previous patch doesn't work.
> How am I supposed to call this ioctl between sgx_encl_alloc and
> sgx_encl_create in sgx_ioc_enclave_create? Even if I somehow manage to call
> this, how is secs->attributes getting set? How do I unset SGX_ATTR_DEBUG?

encl->attributes was previously unused (noticed when I wrote this
patch). It is actually a mask for allowed attributes that is checked
on EINIT. Should rename the variable, yes.

/Jarkko
