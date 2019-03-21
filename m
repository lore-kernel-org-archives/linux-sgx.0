Return-Path: <SRS0=6pva=RY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F782C43381
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 14:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12F6121901
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 14:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbfCUOaZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Mar 2019 10:30:25 -0400
Received: from mga18.intel.com ([134.134.136.126]:11105 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727823AbfCUOaZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 21 Mar 2019 10:30:25 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Mar 2019 07:30:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,253,1549958400"; 
   d="scan'208";a="284640702"
Received: from dilu-mobl2.ccr.corp.intel.com (HELO localhost) ([10.249.254.184])
  by orsmga004.jf.intel.com with ESMTP; 21 Mar 2019 07:30:15 -0700
Date:   Thu, 21 Mar 2019 16:30:13 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v19 17/27] x86/sgx: Add provisioning
Message-ID: <20190321143013.GK4603@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-18-jarkko.sakkinen@linux.intel.com>
 <20190319200912.GH25575@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319200912.GH25575@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 19, 2019 at 01:09:12PM -0700, Sean Christopherson wrote:
> On Sun, Mar 17, 2019 at 11:14:46PM +0200, Jarkko Sakkinen wrote:
> > In order to provide a mechanism for devilering provisoning rights:
> > 
> > 1. Add a new file to the securityfs file called sgx/provision that works
> >    as a token for allowing an enclave to have the provisioning privileges.
> > 2. Add a new ioctl called SGX_IOC_ENCLAVE_SET_ATTRIBUTE that accepts the
> >    following data structure:
> > 
> >    struct sgx_enclave_set_attribute {
> >            __u64 addr;
> >            __u64 token_fd;
> >    };
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
> > 
> > Cc: James Morris <jmorris@namei.org>
> > Cc: Serge E. Hallyn <serge@hallyn.com>
> > Cc: linux-security-module@vger.kernel.org
> > Suggested-by: Andy Lutomirski <luto@kernel.org>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  arch/x86/include/uapi/asm/sgx.h        | 13 +++++++
> >  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 43 +++++++++++++++++++++++
> >  arch/x86/kernel/cpu/sgx/driver/main.c  | 47 ++++++++++++++++++++++++++
> >  3 files changed, 103 insertions(+)
> > 
> > diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> > index aadf9c76e360..150a784db395 100644
> > --- a/arch/x86/include/uapi/asm/sgx.h
> > +++ b/arch/x86/include/uapi/asm/sgx.h
> > @@ -16,6 +16,8 @@
> >  	_IOW(SGX_MAGIC, 0x01, struct sgx_enclave_add_page)
> >  #define SGX_IOC_ENCLAVE_INIT \
> >  	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
> > +#define SGX_IOC_ENCLAVE_SET_ATTRIBUTE \
> > +	_IOW(SGX_MAGIC, 0x03, struct sgx_enclave_set_attribute)
> >  
> >  /* IOCTL return values */
> >  #define SGX_POWER_LOST_ENCLAVE		0x40000000
> > @@ -56,4 +58,15 @@ struct sgx_enclave_init {
> >  	__u64	sigstruct;
> >  };
> >  
> > +/**
> > + * struct sgx_enclave_set_attribute - parameter structure for the
> > + *				      %SGX_IOC_ENCLAVE_INIT ioctl
> > + * @addr:		address within the ELRANGE
> > + * @attribute_fd:	file handle of the attribute file in the securityfs
> > + */
> > +struct sgx_enclave_set_attribute {
> > +	__u64	addr;
> > +	__u64	attribute_fd;
> > +};
> > +
> >  #endif /* _UAPI_ASM_X86_SGX_H */
> > diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > index 4b9a91b53b50..5d85bd3f7876 100644
> > --- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > @@ -759,6 +759,46 @@ static long sgx_ioc_enclave_init(struct file *filep, unsigned int cmd,
> >  	return ret;
> >  }
> >  
> > +/**
> > + * sgx_ioc_enclave_set_attribute - handler for %SGX_IOC_ENCLAVE_SET_ATTRIBUTE
> > + * @filep:	open file to /dev/sgx
> > + * @cmd:	the command value
> > + * @arg:	pointer to a struct sgx_enclave_set_attribute instance
> > + *
> > + * Sets an attribute matching the attribute file that is pointed by the
> > + * parameter structure field attribute_fd.
> 
> With the @data change (see below), this becomes something like:
> 
>  * Allow the enclave to request the attribute managed by the SGX security file
>  * pointed at by the parameter structure field attribute_fd.

I see your point but the current implementation is just a tiny bit
simpler and right now we have one single file.

But I would do to fix this patch right now is to rename
sgx_fs_provision_ops as sgx_fs_ops to point out that only single fops
are required.

The current implementation is "good enough" for handling the
provisioning key.

/Jarkko
