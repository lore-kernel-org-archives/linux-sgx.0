Return-Path: <SRS0=lkUJ=3D=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B976FC33CB2
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Jan 2020 16:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FA8E24655
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Jan 2020 16:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbgANQMu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 Jan 2020 11:12:50 -0500
Received: from mga07.intel.com ([134.134.136.100]:58605 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729263AbgANQMt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 14 Jan 2020 11:12:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2020 08:12:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,433,1571727600"; 
   d="scan'208";a="217788065"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.255.37.212])
  by orsmga008.jf.intel.com with ESMTP; 14 Jan 2020 08:12:45 -0800
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        "Suresh Siddha" <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v24 12/24] x86/sgx: Linux Enclave Driver
Reply-To: haitao.huang@linux.intel.com
References: <20191129231326.18076-1-jarkko.sakkinen@linux.intel.com>
 <20191129231326.18076-13-jarkko.sakkinen@linux.intel.com>
Date:   Tue, 14 Jan 2020 10:12:45 -0600
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.0ed4njqcwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <20191129231326.18076-13-jarkko.sakkinen@linux.intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 29 Nov 2019 17:13:14 -0600, Jarkko Sakkinen  
<jarkko.sakkinen@linux.intel.com> wrote:

> +static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct  
> *sigstruct,
> +			 struct sgx_einittoken *token)
> +{
> +	u64 mrsigner[4];
> +	int ret;
> +	int i;
> +	int j;
> +
> +	/* Check that the required attributes have been authorized. */
> +	if (encl->secs_attributes & ~encl->allowed_attributes)
> +		return -EINVAL;
> +

EACCES to be more specific?

Thanks
Haitao
