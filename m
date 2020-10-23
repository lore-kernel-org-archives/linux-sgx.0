Return-Path: <SRS0=GMJ6=D6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B78C388F9
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Oct 2020 10:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5AA6208C3
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Oct 2020 10:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S462011AbgJWKRu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Oct 2020 06:17:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:25468 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S461988AbgJWKRu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Oct 2020 06:17:50 -0400
IronPort-SDR: A8IA4UzmUDifyKHjT85CA9A59uVoaWk+N+/+FxmIknTZTDFN1QNAijcF0Dqdv+7IP64eEHPYX0
 4GE5UbZXcbBQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9782"; a="185352567"
X-IronPort-AV: E=Sophos;i="5.77,407,1596524400"; 
   d="scan'208";a="185352567"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 03:17:47 -0700
IronPort-SDR: 8R2W1v3NGVDW9ZLWYANyBw7bz22goQZILHJf34zh6h07eJo3OMc2zb6OFpHq7BgJQerIu0fPAg
 BfizRXJhv4OA==
X-IronPort-AV: E=Sophos;i="5.77,407,1596524400"; 
   d="scan'208";a="302629463"
Received: from spiccard-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.41.38])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 03:17:35 -0700
Date:   Fri, 23 Oct 2020 13:17:36 +0300
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
Message-ID: <20201023101736.GG168477@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-16-jarkko.sakkinen@linux.intel.com>
 <7bb4ff7b-0778-ad70-1fe0-6e1db284d45a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bb4ff7b-0778-ad70-1fe0-6e1db284d45a@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Oct 20, 2020 at 02:19:26PM -0700, Dave Hansen wrote:
> On 10/2/20 9:50 PM, Jarkko Sakkinen wrote:
> > + * Failure to explicitly request access to a restricted attribute will cause
> > + * sgx_ioc_enclave_init() to fail.  Currently, the only restricted attribute
> > + * is access to the PROVISION_KEY.
> 
> Could we also justify why access is restricted, please?  Maybe:
> 
> 	Access is restricted because PROVISION_KEY is burned uniquely
> 	into each each processor, making it a perfect unique identifier
> 	with privacy and fingerprinting implications.
> 
> Are there any other reasons for doing it this way?

AFAIK, if I interperet the SDM correctl, PROVISION_KEY and
PROVISION_SEALING_KEY also have random salt added, i.e. they change
every boot cycle.

There is "RAND = yes" on those keys in Table 40-64 of Intel SDM volume
3D :-)

/Jarkko
