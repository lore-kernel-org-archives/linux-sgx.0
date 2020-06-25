Return-Path: <SRS0=RM8m=AG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 474EBC433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 18:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27944207E8
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 18:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390701AbgFYSfK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Jun 2020 14:35:10 -0400
Received: from mga04.intel.com ([192.55.52.120]:46256 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390025AbgFYSfK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 25 Jun 2020 14:35:10 -0400
IronPort-SDR: 0fQ228rc3r+oWij782i+k//EP0WeBT593xXC90inrqZejb0hmLHVz2CGiU/3OEp+4WanzEf6gt
 EoEV3T+gtG7w==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="142530546"
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="142530546"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 11:35:10 -0700
IronPort-SDR: aL4PASQml7wgyj7szJXhpPrZsa4zbVfKDGQzun7rjRPc6UUnaOODbuZ/RKRusjXTdmgFJsRUHg
 +NFjZpLp2YgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="265427085"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 25 Jun 2020 11:35:09 -0700
Date:   Thu, 25 Jun 2020 11:34:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 11/21] x86/sgx: Linux Enclave Driver
Message-ID: <20200625183448.GG3437@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
 <20200625172319.GJ20319@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625172319.GJ20319@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 25, 2020 at 07:23:19PM +0200, Borislav Petkov wrote:
> Also, you had all patches until now split nice and logically doing one
> thing only.
> 
> But this one is huge. Why?
> 
> Why can't you split out the facilities which the driver uses: encl.[ch]
> into a patch, then ioctl.c into a separate one and then the driver into
> a third one? Or do they all belong together inseparably?
> 
> I guess I'll find out eventually but it would've been nice if they were
> split out...

Hmm, I think the most reasonable way to break up this beast would be to
incrementally introduce functionality.  E.g. four or so patches, one for
each ioctl() of ENCLAVE_CREATE, ENCLAVE_ADD_PAGES, ENCLAVE_INIT and
ENCLAVE_SET_ATTRIBUTE, in that order.

Splitting up by file probably wouldn't work very well.  The split is
pretty arbitrary, e.g. encl.[ch] isn't simply a pure representation of an
enclave, there is a lot of the driver details/dependencies in there, i.e.
the functionality between encl/ioctl/driver is all pretty intertwined.

But I think serially introducing each ioctl() would be fairly clean, and
would help readers/reviewers better understand SGX as the patches would
naturally document the process of building an enclave, e.g. CREATE the
enclave, then ADD_PAGES, then INIT the enclave.  SET_ATTRIBUTE is a bit
of an outlier in that it would be chronologically out of order with
respect to building the enclave, but I think that's ok. 

Jarkko, thoughts?
