Return-Path: <SRS0=8iz8=RZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024CCC10F03
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Mar 2019 13:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFA0C2183E
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Mar 2019 13:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730082AbfCVLbu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 Mar 2019 07:31:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:13872 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729848AbfCVLbu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 22 Mar 2019 07:31:50 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Mar 2019 04:31:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,256,1549958400"; 
   d="scan'208";a="216548777"
Received: from vanderss-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.199])
  by orsmga001.jf.intel.com with ESMTP; 22 Mar 2019 04:31:21 -0700
Date:   Fri, 22 Mar 2019 13:31:20 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v19 17/27] x86/sgx: Add provisioning
Message-ID: <20190322113120.GK3122@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-18-jarkko.sakkinen@linux.intel.com>
 <20190319200912.GH25575@linux.intel.com>
 <1553134108.1952.4.camel@intel.com>
 <20190321143208.GL4603@linux.intel.com>
 <105F7BF4D0229846AF094488D65A0989356E6613@PGSMSX112.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <105F7BF4D0229846AF094488D65A0989356E6613@PGSMSX112.gar.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 21, 2019 at 09:41:37PM +0000, Huang, Kai wrote:
> > On Thu, Mar 21, 2019 at 02:08:36AM +0000, Huang, Kai wrote:
> > > On Tue, 2019-03-19 at 13:09 -0700, Sean Christopherson wrote:
> > > > On Sun, Mar 17, 2019 at 11:14:46PM +0200, Jarkko Sakkinen wrote:
> > > > > In order to provide a mechanism for devilering provisoning rights:
> > > > >
> > > > > 1. Add a new file to the securityfs file called sgx/provision that works
> > > > >    as a token for allowing an enclave to have the provisioning privileges.
> > > > > 2. Add a new ioctl called SGX_IOC_ENCLAVE_SET_ATTRIBUTE that
> > accepts the
> > > > >    following data structure:
> > > > >
> > > > >    struct sgx_enclave_set_attribute {
> > > > >            __u64 addr;
> > > > >            __u64 token_fd;
> > > > >    };
> > >
> > > Would you elaborate why the name is "token_fd"? I think *token* in SGX
> > > has more specific meaning?
> > 
> > I'm open for other names.
> 
> How about attribute_fd, which is consistent with your IOCTL?

I'm cool with that name! Thanks.

/Jarkko
