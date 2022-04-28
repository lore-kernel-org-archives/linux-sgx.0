Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F87C433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Apr 2022 21:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235725AbiD1VeQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Apr 2022 17:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352340AbiD1Vd5 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 28 Apr 2022 17:33:57 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492F87378A
        for <linux-sgx@vger.kernel.org>; Thu, 28 Apr 2022 14:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651181441; x=1682717441;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EWxNvt2b3zDas2gLY52ISqdVunCSwtmxwT3/oYy7Iok=;
  b=BD/Uv0wUw7EoMadGybUjfKrFcJMd56HGtfGB5jZzpYUABGZ2hNhTNUOm
   jxVjgw7rUph3s5GFLNOEfTkCGigsrqvu9Ky0Q1VbEvUDVbFfuYS9WygUN
   XoeqLkgZDZClJCfUf63q+xggxzFuSaPf0ohuylOk2gx0e3SQaUD5hBdY3
   1bBmvZeCZyQhWew4FzqS5do4eSH+MQpeORtcnsiJmh/YUJzgt71GnwWAs
   ilRg1UFi3Q9GDquC3AlG56h6+HzrjE9YIW3KIIQMZXeJpWYEQjnQn3zmN
   4Qgtd1rDKTBzCyPXAQbOevNSjesncbJrn5FQO2Yn2o4/kRwV4bp8Zv9oc
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="265957592"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="265957592"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 14:30:40 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="581652370"
Received: from mpoursae-mobl2.amr.corp.intel.com (HELO [10.212.0.84]) ([10.212.0.84])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 14:30:39 -0700
Message-ID: <a43b87b3-ba9f-c442-295c-cef84d6f8318@intel.com>
Date:   Thu, 28 Apr 2022 14:30:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH 1/4] x86/sgx: Do not free backing memory on
 ENCLS[ELDU] failure
Content-Language: en-US
To:     Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, jarkko@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <6fad9ec14ee94eaeb6d287988db60875da83b7bb.1651171455.git.reinette.chatre@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <6fad9ec14ee94eaeb6d287988db60875da83b7bb.1651171455.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 4/28/22 13:11, Reinette Chatre wrote:
> 
> The backing storage is freed after running ENCLS[ELDU],
> whether ENCLS[ELDU] succeeded or not. If ENCLS[ELDU]
> thus failed then the data within that page is lost.
> 
> Exit with error without removing the backing storage if
> it could not be restored to the enclave.
> 
> Fixes: 08999b2489b4 ("x86/sgx: Free backing memory after faulting the enclave page")
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 1a2cbe44b8d9..e5d2661800ac 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -81,6 +81,10 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>  			ENCLS_WARN(ret, "ELDU");
>  
>  		ret = -EFAULT;
> +		kunmap_atomic(pcmd_page);
> +		kunmap_atomic((void *)(unsigned long)pginfo.contents);
> +		sgx_encl_put_backing(&b, false);
> +		return ret;
>  	}
>  
>  	memset(pcmd_page + b.pcmd_offset, 0, sizeof(struct sgx_pcmd));

Are there any transient, recoverable errors that can come back from
ELDU?  If so, this makes a lot of sense.  If not, then it doesn't make a
lot of sense to preserve the swapped-out content because they enclave is
going to die anyway.
