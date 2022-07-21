Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30475C433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Jul 2022 16:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbiGUQmh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Jul 2022 12:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiGUQmh (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 21 Jul 2022 12:42:37 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9F780F42
        for <linux-sgx@vger.kernel.org>; Thu, 21 Jul 2022 09:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658421756; x=1689957756;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Q74zMSjVW3u+S+6GpIAC3Uoeobj/pRcAUBaDQN6WMlI=;
  b=m3WEYOWJ/QEtL3N1K62jbD/oZpkRReAeM2uKcNzWHyMXyf6UXABZlw3S
   fJxH0jnq7KPp0kCSBWlt+HtZPqv6KMW67cozRT6n+ekONtGm9ZWIID+KT
   F5Ye5ky1TI+1MVq55JMRFzCOFbN2g91QPMctkEBaHg9c/ybVuATcsGuZx
   xofUvx8q/Kp/GValQuNKBtS4P4EQowMZVzhlTXCBzKdV1qOeQ5XI3/EBU
   SMPQVWkS1D99xxZT7AFhOm606jAOQK1se0EXd57nJeVu+MqLpq2CGYJ6t
   e3G0222nqvuQkxxzUsBHYp66gtk7Cb45FJdPNEvHv+VuXlQx6IIrMbCM4
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="351092598"
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="351092598"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 09:42:36 -0700
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="573814359"
Received: from vasantgx-mobl.amr.corp.intel.com (HELO [10.212.244.191]) ([10.212.244.191])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 09:42:35 -0700
Message-ID: <111cc85d-0e49-ad45-84e9-1a71ce58a2ca@intel.com>
Date:   Thu, 21 Jul 2022 09:42:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v5 1/3] x86/sgx: Repurpose the owner field as the virtual
 address of virtual EPC page
Content-Language: en-US
To:     Zhiquan Li <zhiquan1.li@intel.com>, linux-sgx@vger.kernel.org,
        tony.luck@intel.com, jarkko@kernel.org, dave.hansen@linux.intel.com
Cc:     seanjc@google.com, kai.huang@intel.com, fan.du@intel.com,
        cathy.zhang@intel.com
References: <20220622093705.2891642-1-zhiquan1.li@intel.com>
 <20220622093705.2891642-2-zhiquan1.li@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20220622093705.2891642-2-zhiquan1.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/22/22 02:37, Zhiquan Li wrote:
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> index 6a77a14eee38..776ae5c1c032 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -46,10 +46,12 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
>  	if (epc_page)
>  		return 0;
>  
> -	epc_page = sgx_alloc_epc_page(vepc, false);
> +	epc_page = sgx_alloc_epc_page((void *)addr, false);
>  	if (IS_ERR(epc_page))
>  		return PTR_ERR(epc_page);

Was the 'vepc' value simply unused before?
