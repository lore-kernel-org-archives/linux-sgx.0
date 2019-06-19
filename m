Return-Path: <SRS0=/aec=US=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E65ADC31E49
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 13:24:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCF08206E0
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 13:24:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbfFSNYZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Jun 2019 09:24:25 -0400
Received: from mga06.intel.com ([134.134.136.31]:27037 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbfFSNYZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Jun 2019 09:24:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 06:24:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,392,1557212400"; 
   d="scan'208";a="170560773"
Received: from stephanf-mobl2.ger.corp.intel.com ([10.252.34.117])
  by orsmga002.jf.intel.com with ESMTP; 19 Jun 2019 06:24:22 -0700
Message-ID: <38501f172141cde8d525ca82003f498911eb2614.camel@linux.intel.com>
Subject: Re: [RFC PATCH v3 02/12] x86/sgx: Do not naturally align MAP_FIXED
 address
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
In-Reply-To: <20190617222438.2080-3-sean.j.christopherson@intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
         <20190617222438.2080-3-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160
 Espoo
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Date:   Wed, 19 Jun 2019 16:24:05 +0300
User-Agent: Evolution 3.32.1-2 
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2019-06-17 at 15:24 -0700, Sean Christopherson wrote:
>  {
> -	if (len < 2 * PAGE_SIZE || len & (len - 1) || flags & MAP_PRIVATE)
> +	if (flags & MAP_PRIVATE)
> +		return -EINVAL;
> +
> +	if (flags & MAP_FIXED)
> +		return addr;
> +
> +	if (len < 2 * PAGE_SIZE || len & (len - 1))
>  		return -EINVAL;
>
>  	addr = current->mm->get_unmapped_area(file, addr, 2 * len, pgoff,

Just sanity checking that for MAP_FIXED case the mm checks that the area is
unmapped before calling this?

I don't think we need to check any alignment constraints here anymore.

The summarize end result would be:

static unsigned long sgx_get_unmapped_area(struct file *file,
					   unsigned long addr,
					   unsigned long len,
					   unsigned long pgoff,
					   unsigned long flags)
{
	if (flags & MAP_PRIVATE)
		return -EINVAL;

	if (flags & MAP_FIXED)
		return addr;

	return current->mm->get_unmapped_area(file, addr, 2 * len, pgoff,
					      flags);
}

/Jarkko

