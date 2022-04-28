Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 563D9C433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Apr 2022 21:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbiD1Vn3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Apr 2022 17:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbiD1Vn2 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 28 Apr 2022 17:43:28 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1141B9FF7
        for <linux-sgx@vger.kernel.org>; Thu, 28 Apr 2022 14:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651182012; x=1682718012;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sLjqgZh6BSLKJChTLhoDxSmcy0CF8c0hJmGk7oNSffk=;
  b=W+d7BlqAlitA770GAWufZ06FdycfW4RjSN1X2C/C07bfu9LAHGoMFvht
   N3HwnYCnX+FHJH6xB4B9CWyHjGgDkWA+/egm62mnA/rsGonsjmupkhTlA
   ueGP41eFwlzYl5F4yWMtnuZbEJ9FRugOLtmKL3V/gQVn4TX42i6J/urCx
   /tXAm8/UDZBOYYP8ZjYEWxwRk8S/dJsRQRGoKiSb0ctUDd2UYf+LUIny2
   dM5sjIA+juqai4OK1GT2gNYZhf348YE+vbDP1QNnuzFlZj1kRifzAzBrl
   xFkeO/fl3uRb5AbwjGJq+t+mC8KM1uFFMwijfFrg2KCNyWCgcltVIgB4k
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="265960221"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="265960221"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 14:40:11 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="581657310"
Received: from mpoursae-mobl2.amr.corp.intel.com (HELO [10.212.0.84]) ([10.212.0.84])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 14:40:10 -0700
Message-ID: <8231188d-b3af-4395-3d8b-129d500474ce@intel.com>
Date:   Thu, 28 Apr 2022 14:40:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH 2/4] x86/sgx: Set dirty bit after modifying page
 contents
Content-Language: en-US
To:     Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, jarkko@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <b0596095e09ee4a14a3802c5ce91372a0dc21220.1651171455.git.reinette.chatre@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <b0596095e09ee4a14a3802c5ce91372a0dc21220.1651171455.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 4/28/22 13:11, Reinette Chatre wrote:
> 
> Since the PCMD page in the backing store is modified the page
> should be set as dirty when releasing the reference to
> ensure the modified data is retained.
> 
> Fixes: 08999b2489b4 ("x86/sgx: Free backing memory after faulting the enclave page")
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index e5d2661800ac..e03f124ce772 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -98,7 +98,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>  	kunmap_atomic(pcmd_page);
>  	kunmap_atomic((void *)(unsigned long)pginfo.contents);
>  
> -	sgx_encl_put_backing(&b, false);
> +	sgx_encl_put_backing(&b, true);

I think you're on the right track here.  The concept is right.  The
memset() wrote fresh data into the b.pcmd page.  But, if it were clean
swap cache, it can be discarded again and the memset() might be lost.

I *think* all that would do in the end is leave us with a PCMD page that
will never be truncated because the page has non-zero PCMD data that
will never be used, the result of the thrown-away memset().

But, I'd rather this be done more directly and closer to the actual
dirtying of the page.  Perhaps:

+	set_page_dirty(b.pcmd);
        memset(pcmd_page + b.pcmd_offset, 0, sizeof(struct sgx_pcmd));


I don't think the "b.contents" page needs the same treatment because its
contents are always discarded in this path while some of the PCMD page's
contents need to be preserved.
