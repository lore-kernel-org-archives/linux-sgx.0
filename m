Return-Path: <SRS0=O4vE=7E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59AE1C433E0
	for <linux-sgx@archiver.kernel.org>; Fri, 22 May 2020 07:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C6FE2072C
	for <linux-sgx@archiver.kernel.org>; Fri, 22 May 2020 07:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgEVHPz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 May 2020 03:15:55 -0400
Received: from mga04.intel.com ([192.55.52.120]:46811 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728137AbgEVHPy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 22 May 2020 03:15:54 -0400
IronPort-SDR: 7LB6WXHDPmM5eZ9wK08infduL20Nr1uKLQZyiXyjjejKYhV8/NVZA5cGiA2Cex/A64K83C3JCM
 8GZUUCIli0uQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 00:15:54 -0700
IronPort-SDR: KY8FM2XvlW2PX8YM2WYKJFEgZsnlmqCYvrpnrZfhR2WhTrdD09HCdYjmObussU4WB2N7Dvyhfl
 x4YJVhq0HkFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,420,1583222400"; 
   d="scan'208";a="255525320"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 22 May 2020 00:15:53 -0700
Date:   Fri, 22 May 2020 00:15:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-mm@kvack.org, Jethro Beekman <jethro@fortanix.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Seth Moore <sethmo@google.com>
Subject: Re: [PATCH v30 12/20] x86/sgx: Add a page reclaimer
Message-ID: <20200522071553.GA24377@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-13-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515004410.723949-13-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 15, 2020 at 03:44:02AM +0300, Jarkko Sakkinen wrote:
> +static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
> +				struct sgx_backing *backing)
> +{
> +	struct sgx_encl_page *encl_page = epc_page->owner;
> +	struct sgx_encl *encl = encl_page->encl;
> +	struct sgx_backing secs_backing;
> +	int ret;
> +
> +	mutex_lock(&encl->lock);
> +
> +	if (atomic_read(&encl->flags) & SGX_ENCL_DEAD) {
> +		ret = __eremove(sgx_epc_addr(epc_page));
> +		ENCLS_WARN(ret, "EREMOVE returned %d\n");

The " returned %d\n" is unnecessary and leads to a bad message, ENCLS_WARN
handles the message and formatting, i.e. this should simply be:

		ENCLS_WARN(ret, "EREMOVE");

> +	} else {
> +		sgx_encl_ewb(epc_page, backing);
> +	}
> +
> +	encl_page->epc_page = NULL;
> +	encl->secs_child_cnt--;
