Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B2EEC28D13
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Aug 2022 23:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238620AbiHVXYy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 22 Aug 2022 19:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238413AbiHVXYx (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 22 Aug 2022 19:24:53 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DAD550B4
        for <linux-sgx@vger.kernel.org>; Mon, 22 Aug 2022 16:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661210691; x=1692746691;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VEMn6o0K8JaqtqVDC9nFPmjeOUH8senNegF/mKldee8=;
  b=mKc3Sv2OOZS606IimBVXrXkw5eqThIHsSgA3+SUSrJPS4QXL1RV6Aj55
   XWD6ZxqFKnywaUlPIfB61svIjL0xGSv1aobfswtOCKrrjWWFNILQynCyk
   bNqpKyyN8inMmCH+qDfJZbDAo2LFxBtsQAKne/i54v4fh1jbQu87LTgOM
   BC6ndRE1rjxWwb3e9DZtIiIdC9mm+evvrtupmt/KnWCXHXlkzHa2ierhW
   l5OcHpSc2dHAq2E+ecfVP5CBqdcIdJ2bLxJwldqH9HdrIB2nRunIVcqP0
   x9rgQQNllkIzznqHyjF32OL2DZLW/7uy2MQgdrdM4SJVPpfcSVXv2udvL
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="319583311"
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="319583311"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 16:24:50 -0700
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="751470714"
Received: from jcsarker-mobl.amr.corp.intel.com (HELO [10.212.204.203]) ([10.212.204.203])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 16:24:50 -0700
Message-ID: <86165137-fbbf-6747-cd55-7e807aab9a6c@intel.com>
Date:   Mon, 22 Aug 2022 16:24:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] selftests/sgx: retry the ioctls returned with EAGAIN
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, reinette.chatre@intel.com,
        Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>
References: <YvlPYRvMicz9CPFQ@kernel.org>
 <20220816051656.3622-1-haitao.huang@linux.intel.com>
 <Yvuok/Xd7+/kcUiR@kernel.org>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <Yvuok/Xd7+/kcUiR@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 8/16/22 07:24, Jarkko Sakkinen wrote:
> Dave, in addition to [*], these should be picked x86 tree for v6.0
> 
> https://lore.kernel.org/linux-sgx/20220815233900.11225-1-jarkko@kernel.org/T/#t

Was there an ack somewhere in that thread that I missed?
