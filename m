Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E04C00144
	for <linux-sgx@archiver.kernel.org>; Fri, 29 Jul 2022 16:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237827AbiG2Qih (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 29 Jul 2022 12:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237814AbiG2QiD (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 29 Jul 2022 12:38:03 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DAD88CEB
        for <linux-sgx@vger.kernel.org>; Fri, 29 Jul 2022 09:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659112677; x=1690648677;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nHsf/steoiIFgq63RGl4wMOjTZ3LbFAg/0MYv/YuRa4=;
  b=S6hbblQ5tIHAjY4EuDTeCEV++keX+BrNlA4I0mStR6bS3nHZKW/me/PG
   pFekn/Y2iQl/nkXqRQ9slPhKDoZnRCN9WVTCWvB+RkzaZuutcudDP1jjW
   NFwCE3u9hGFZkpHP+Ph96U7NZIyThLqUm5wa0TwQriWzI4UpvbnkveppN
   pWMv2UFMLIMBwpVj3bT10PpNfFVxWKK3SP4Fnd9MjuoyFy3St1605++X1
   u8/57j29jGGGMdTHdGR4OhB3DC+pyxHwOPoKcu53tABbLCh5S+jJMp9LC
   XYAg1ui+f9Oer4Gcz6mTw6DIh5cgVdLpYRt7ApOwrQyUbHMHoejUaXWlN
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10423"; a="271843373"
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="271843373"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 09:37:56 -0700
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="669323225"
Received: from svdas-mobl.amr.corp.intel.com (HELO [10.209.20.175]) ([10.209.20.175])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 09:37:56 -0700
Message-ID: <1600d7b3-24c2-7455-4a7f-56366ccd03aa@intel.com>
Date:   Fri, 29 Jul 2022 09:37:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Support SGX2 V5: Seg-fault with EACCEPT for large number of EPC
 pages
Content-Language: en-US
To:     "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Cc:     "Huang, Haitao" <haitao.huang@intel.com>
References: <DM8PR11MB55912A7F47A84EC9913A6352F6999@DM8PR11MB5591.namprd11.prod.outlook.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <DM8PR11MB55912A7F47A84EC9913A6352F6999@DM8PR11MB5591.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/29/22 09:01, Dhanraj, Vijay wrote:
> Huang, Haitao and I created a simple patch to repro this issue using the SGX selftests and we do see the issue when using V5 (5.18.0-rc5) but cannot repro the issue in V4 (5.18.0-rc2). Not sure if this is a driver issue or kernel, can you please check?

Thanks for the report.

Could you please try the code that's going to go to Linus shortly?  It's
really the only version that matters at this point?

https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/log/?h=x86/sgx
