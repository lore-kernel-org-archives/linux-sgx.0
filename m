Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB07C001B0
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Aug 2023 20:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjHGUN7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 7 Aug 2023 16:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjHGUN7 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 7 Aug 2023 16:13:59 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C2510D8
        for <linux-sgx@vger.kernel.org>; Mon,  7 Aug 2023 13:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691439238; x=1722975238;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=eLV5QN1JNaCHwkNte9jSaAToS3r/GiNV1cZEgIcMRYQ=;
  b=in2npGb71mP8RdFRabRlvZSw4UMZ/GiBR/wRswY+9JyS8uYmHxRAJjgz
   fMGdCTfsbQUbAd7yKQMExpBsWX6O6wi77gGYWfhIU6KWc0HD2CLLbgQ6P
   gEfCvgX1SEDLHL++cZ3KdxcM/baWYSfu6RiVYq+zW0zJ7TaE07xwYQcjq
   9AwudUgPipQfRxrEoXimNWq0EtaQNpE0FraDd6bzODtT/TaNFBkRyXoc2
   2PJdEj20eNWF06n3pChUyIFJwV7tyB3sgc3Zv9xtf5EgbjEmj0OlEU8xy
   p7lUbazXLiC6qaTRg0kmdna8mcQ7/8OTzsSeVvQoezdB4hngagpd5MvMu
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="370632731"
X-IronPort-AV: E=Sophos;i="6.01,262,1684825200"; 
   d="scan'208";a="370632731"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2023 13:13:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="854798320"
X-IronPort-AV: E=Sophos;i="6.01,262,1684825200"; 
   d="scan'208";a="854798320"
Received: from nyamoah-mobl.amr.corp.intel.com (HELO [10.212.249.113]) ([10.212.249.113])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2023 13:13:57 -0700
Message-ID: <ee73c85e-6e9d-1294-6e38-356f57559ace@intel.com>
Date:   Mon, 7 Aug 2023 13:13:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: SGX Memory Reservation on SPR
Content-Language: en-US
To:     Haitao Huang <haitao.huang@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Shutemov, Kirill" <kirill.shutemov@intel.com>
References: <ce32998f-1d7f-9481-ddb8-961b5d0f6a83@intel.com>
 <op.19a6ljf3wjvjmi@hhuan26-mobl.amr.corp.intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <op.19a6ljf3wjvjmi@hhuan26-mobl.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 8/7/23 06:33, Haitao Huang wrote:
> Hi Dave
> On Fri, 04 Aug 2023 16:06:50 -0500, Dave Hansen <dave.hansen@intel.com>
> wrote:
> 
>> What choices do our end users have about how much EPC RAM to dedicate to
>> SGX on SPR systems?  I assume there's some ability to tweak to tweak it
>> in the BIOS.
> 
> On one platform I know, BIOS provides choices from 256M to 256G,
> doubling at each increment. This should depend on OEM/BIOS and available
> total RAM configured.

OK, thanks.  I was mostly curious how much RAM our customers are burning
on SGX just so they can do TDX attestation on SPR.
