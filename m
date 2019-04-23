Return-Path: <SRS0=01IT=SZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94947C10F14
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 14:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F28B21738
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 14:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfDWOd0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 23 Apr 2019 10:33:26 -0400
Received: from mga04.intel.com ([192.55.52.120]:59062 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbfDWOdZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 23 Apr 2019 10:33:25 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP; 23 Apr 2019 07:33:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,386,1549958400"; 
   d="scan'208";a="138092169"
Received: from sbwarrax-mobl1.gar.corp.intel.com (HELO localhost) ([10.252.58.123])
  by orsmga006.jf.intel.com with ESMTP; 23 Apr 2019 07:33:11 -0700
Date:   Tue, 23 Apr 2019 17:33:09 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Svahn, Kai" <kai.svahn@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v20 16/28] x86/sgx: Add provisioning
Message-ID: <20190423143309.GB26642@linux.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <20190417103938.7762-17-jarkko.sakkinen@linux.intel.com>
 <1555643200.2776.1.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1555643200.2776.1.camel@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 19, 2019 at 03:06:48AM +0000, Huang, Kai wrote:
> On Wed, 2019-04-17 at 13:39 +0300, Jarkko Sakkinen wrote:
> > In order to provide a mechanism for devilering provisoning rights:
> > 
> > 1. Add a new device file /dev/sgx/provision that works as a token for
> >    allowing an enclave to have the provisioning privileges.
> > 2. Add a new ioctl called SGX_IOC_ENCLAVE_SET_ATTRIBUTE that accepts the
> >    following data structure:
> > 
> >    struct sgx_enclave_set_attribute {
> >            __u64 addr;
> >            __u64 attribute_fd;
> >    };
> > 
> > A daemon could sit on top of /dev/sgx/provision and send a file
> > descriptor of this file to a process that needs to be able to provision
> > enclaves.
> > 
> > The way this API is used is straight-forward. Lets assume that dev_fd is
> > a handle to /dev/sgx/enclave and prov_fd is a handle to
> > /dev/sgx/provision.  You would allow SGX_IOC_ENCLAVE_CREATE to
> > initialize an enclave with the PROVISIONKEY attribute by
> > 
> > params.addr = <enclave address>;
> > params.token_fd = prov_fd;
> > 
> Should be params.attribute_fd = prov_fd;
> 
> Thanks,
> -Kai

Thanks.

/Jarkko
