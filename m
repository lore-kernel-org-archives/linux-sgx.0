Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5264AC433FE
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Oct 2022 15:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiJMPkf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Oct 2022 11:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiJMPkK (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 13 Oct 2022 11:40:10 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD5D2870F
        for <linux-sgx@vger.kernel.org>; Thu, 13 Oct 2022 08:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665675592; x=1697211592;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fUjs+JBmr1K4wvNXIn5fRYjrZpP+f5hwHGkI/oQ3b4o=;
  b=MhuLoSMaWMjDKTa8Y6IMLLFBCyJvW+8jyHW/+g5wgBwNvx0GQDAauVbG
   9vHbSz/y4K15vlwTFshUKE/a427uKz4A/SN+xdOE3LTPZxhxlNv3wwev/
   yYk3sX9ReJTuinv+bzknu5BnKpGesu3xradKjYk9S8N41OHJR+9dpGdmv
   plm8HfE/EeIXcRvgy6m7M6TTd8L2R6RDfTp9V3UKMMsLk9jYNKsclcdKF
   hEnNFTe22F592PjhXIDkJtejRv6h7lVes+L6QXK3hib0TascVsTNIXCBh
   7e6YoDZVG/1vMDPFoXaJiQjno+WQ9m6vJxhACkr1xq/zqRGraQG0I9CPE
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="331619953"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="331619953"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 08:39:51 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="660379312"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="660379312"
Received: from mkucejko-mobl.ger.corp.intel.com (HELO [10.213.24.166]) ([10.213.24.166])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 08:39:45 -0700
Message-ID: <b2dd91b1-9b9f-6b41-4cb9-80dd99837480@intel.com>
Date:   Thu, 13 Oct 2022 08:39:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Content-Language: en-US
To:     Zhiquan Li <zhiquan1.li@intel.com>, linux-sgx@vger.kernel.org,
        tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com, kai.huang@intel.com
Cc:     seanjc@google.com, fan.du@intel.com, cathy.zhang@intel.com,
        bp@suse.de, tglx@linutronix.de
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
 <20220920063948.3556917-4-zhiquan1.li@intel.com>
 <b775a187-32ad-836f-557f-3486ef4ac8dd@intel.com>
 <14fabc80-a9fc-05b4-eda1-62f2b265e66b@intel.com>
 <f8b49a6b-44ce-9477-b2ba-39abadfbd68f@intel.com>
 <fb885d7f-388c-6a53-798b-06805fefca3d@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <fb885d7f-388c-6a53-798b-06805fefca3d@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 10/13/22 07:40, Zhiquan Li wrote:
> 	There is already a signal-based ABI to tell userspace about
> 	machine checks.  But, SGX does not use that ABI.  Today, the
> 	kernel delivers a generic SIGBUS if a machine check occurs when
> 	accessing SGX memory.  Userspace can not differentiate that
> 	SIGBUS from <a recoverable machine check error>,

I wanted an example here of a SIGBUS that can occur from sources *OTHER*
than a recoverable machine check.
