Return-Path: <SRS0=PkQm=3M=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55328C2D0DB
	for <linux-sgx@archiver.kernel.org>; Thu, 23 Jan 2020 12:31:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32A422467B
	for <linux-sgx@archiver.kernel.org>; Thu, 23 Jan 2020 12:31:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgAWMbs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 23 Jan 2020 07:31:48 -0500
Received: from mga18.intel.com ([134.134.136.126]:63130 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbgAWMbs (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 23 Jan 2020 07:31:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jan 2020 04:31:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,353,1574150400"; 
   d="scan'208";a="220652634"
Received: from wkalinsk-mobl.ger.corp.intel.com ([10.252.23.16])
  by orsmga008.jf.intel.com with ESMTP; 23 Jan 2020 04:31:37 -0800
Message-ID: <850ecd66bf6f0bf59aa96e93f664bbe571c91009.camel@linux.intel.com>
Subject: Re: [PATCH v24 12/24] x86/sgx: Linux Enclave Driver
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     haitao.huang@linux.intel.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Thu, 23 Jan 2020 14:31:36 +0200
In-Reply-To: <op.0ed4njqcwjvjmi@hhuan26-mobl.amr.corp.intel.com>
References: <20191129231326.18076-1-jarkko.sakkinen@linux.intel.com>
         <20191129231326.18076-13-jarkko.sakkinen@linux.intel.com>
         <op.0ed4njqcwjvjmi@hhuan26-mobl.amr.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 2020-01-14 at 10:12 -0600, Haitao Huang wrote:
> On Fri, 29 Nov 2019 17:13:14 -0600, Jarkko Sakkinen  
> <jarkko.sakkinen@linux.intel.com> wrote:
> 
> > +static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct  
> > *sigstruct,
> > +			 struct sgx_einittoken *token)
> > +{
> > +	u64 mrsigner[4];
> > +	int ret;
> > +	int i;
> > +	int j;
> > +
> > +	/* Check that the required attributes have been authorized. */
> > +	if (encl->secs_attributes & ~encl->allowed_attributes)
> > +		return -EINVAL;
> > +
> 
> EACCES to be more specific?

I'd say it'd be especially since it is our artificial access control
check and not something directly in the uarch. Thanks for the remark
I updated my master branch.

/Jarkko

