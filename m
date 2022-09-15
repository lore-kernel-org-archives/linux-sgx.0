Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57AE5C32771
	for <linux-sgx@archiver.kernel.org>; Thu, 15 Sep 2022 20:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiIOUAH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 15 Sep 2022 16:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiIOUAF (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 15 Sep 2022 16:00:05 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD5D45F52
        for <linux-sgx@vger.kernel.org>; Thu, 15 Sep 2022 13:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663272003; x=1694808003;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=cs1nuIOnP70E+xTHHsDc7FVI2GneIo/88cvU4YeN6jU=;
  b=NUjY92ySmsvVnsaj92sAuUtTQDhGuvgrC5UlyPt+j6LJEvsAYH56IF3W
   5XhwQ9HyOfJEDe/bIr/fAOVCiP9npv6EKN7bDrp5a7Kc+uJOIPH2lEuDH
   NRMcvqQG8i9cJO+ZB8tZl4OahmzAeE5jJWHSJDaSnQFdYO3agqd1Y49n1
   9s6sbx/NyyjDvBTt2vyd22jAigZpFkYRl0GKjtBdKW1Q1NeBev60GfO/d
   c36YvsFfH939JRB3/rULWS9qNNEYE73HZoXOFA/VaDmx5Z7KcCaAJ5d5h
   zLMq7dVgVtf7ihwKcGQHH4M2OBmd+J8WkXVaTamFjeJ1djfzUJ/YTmRam
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="297547765"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="297547765"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 13:00:03 -0700
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="594970196"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO hhuan26-mobl1.mshome.net) ([10.209.157.190])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 15 Sep 2022 13:00:01 -0700
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        "Zhiquan Li" <zhiquan1.li@intel.com>
Cc:     seanjc@google.com, kai.huang@intel.com, fan.du@intel.com,
        cathy.zhang@intel.com
Subject: Re: [PATCH v8 2/3] x86/sgx: Introduce union with vepc_vaddr field for
 virtualization case
References: <20220913145330.2998212-1-zhiquan1.li@intel.com>
 <20220913145330.2998212-3-zhiquan1.li@intel.com>
 <op.1shsrfrrwjvjmi@hhuan26-mobl1.mshome.net>
 <48f10df1-f5ac-cd66-032a-5648989b8aba@intel.com>
Date:   Thu, 15 Sep 2022 15:00:00 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: Quoted-Printable
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.1sjy6abswjvjmi@hhuan26-mobl1.mshome.net>
In-Reply-To: <48f10df1-f5ac-cd66-032a-5648989b8aba@intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 14 Sep 2022 21:22:33 -0500, Zhiquan Li <zhiquan1.li@intel.com>  =

wrote:

>
> On 2022/9/14 23:46, Haitao Huang wrote:
>> Maybe it's just me missing some prior knowledge. It's not obvious to =
me
>> why you don't need any guard accessing the encl_owner field in ksgxd
>> thread. Is it because all vepc pages are never put in the active list=

>> and encl_owner would never be null for all pages in that list?
>
> Yes, all vepc pages are never put in the active list. The SGX core pag=
e
> reclaimer doesn=E2=80=99t support reclaiming EPC pages allocated to KV=
M guests
> through the virtual EPC driver.
>
>> Regardless, could you add a few sentence here to to make the rule  =

>> explicit?
>
> More details please see the section "Virtual EPC" at
> Documentation/x86/sgx.rst.
>
Thanks for pointing to that.
Haitao
