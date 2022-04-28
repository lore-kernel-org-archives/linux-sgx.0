Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86714C433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Apr 2022 21:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbiD1WBw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Apr 2022 18:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352590AbiD1WBv (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 28 Apr 2022 18:01:51 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92C6580DF
        for <linux-sgx@vger.kernel.org>; Thu, 28 Apr 2022 14:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651183115; x=1682719115;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=p0Com3VCz3Hoo3CTMIovwkE4X8t4/ChE1c1Dr66LPbw=;
  b=O/x3WgaWD0o3J40PBClTTLZ3ipf08jGIsOSlqoub7UBsK83S19LYfbLY
   0ECnGmbo1b6glpYYx+ciX+0bhh9h/pGr3ua62prCpUenr4Sb92nJoJqbB
   DhhvIwNBhn3GzSnktLhne7BRVn5EcDQUD/0+B4TVNCWOaiZASKvXFUruT
   MIrn/cDj9AHABh62Z/DNaJ8nH+2++u0EKQt3ZbHbqyfhBTU/+ICzgSjp0
   WszAuQ5TFxbKW33dGeCAG1bnUtsJKWnnC7yPPs36Qs4YoqvoVHm1mgofS
   bFor6DUO704AtD8JPdPH+unsoRXTAC5pgSBdiLjvsLcA7CLBt3xNydQqN
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="266594497"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="266594497"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 14:58:35 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="581665745"
Received: from mpoursae-mobl2.amr.corp.intel.com (HELO [10.212.0.84]) ([10.212.0.84])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 14:58:34 -0700
Message-ID: <7b68a719-a949-d920-337f-0be72316eb82@intel.com>
Date:   Thu, 28 Apr 2022 14:58:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH 3/4] x86/sgx: Obtain backing storage page with enclave
 mutex held
Content-Language: en-US
To:     Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, jarkko@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <24fd9203331d11918b785c6a67f85d799d100be8.1651171455.git.reinette.chatre@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <24fd9203331d11918b785c6a67f85d799d100be8.1651171455.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 4/28/22 13:11, Reinette Chatre wrote:
> @@ -252,6 +252,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
>  	sgx_encl_ewb(epc_page, backing);
>  	encl_page->epc_page = NULL;
>  	encl->secs_child_cnt--;
> +	sgx_encl_put_backing(backing, true);

Could you also talk a bit about why this needed to move?  It's a bit
harder to make sense of the refcounting when the get and put are done in
different functions.
