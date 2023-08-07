Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C6BC001DB
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Aug 2023 13:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbjHGNek (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 7 Aug 2023 09:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233952AbjHGNej (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 7 Aug 2023 09:34:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867111701
        for <linux-sgx@vger.kernel.org>; Mon,  7 Aug 2023 06:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691415268; x=1722951268;
  h=to:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=D9Jwk9heC5HXWFyiAnHcDJkJ3JPuck75g25lZtW0skM=;
  b=FPJ51NLrWhr7WmEIrMcJusfoP9NWNnsSPDtXBktIZhAASuLDld6LhFDy
   x/Mkx3aBcVGvnBjMKj9pkq8H5YPZPLOWGxnowkirgLLC5YoEEHoIBf0t+
   CHnzoBTWu7uYO4cdmD9M/6Gt8WF8sM8/rU+qtEsPbQOgnPNGOU8yIwzKe
   dKp/T50GiMuzPoVZaG1HhGqNUl+V+GIjvoPlNJPSLnV7anP2RWdGC/3ln
   ORvys0U9h0SAkDQwbyN3to5dNZ1I8IGIUd/t+D9YPBnW7nbTNtto5W7za
   bunx4Ootvz2NihXHzdAmPckuKnA1ZaFuDfTM9fOJnv2JM6wjWVqTSHcxO
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="350137304"
X-IronPort-AV: E=Sophos;i="6.01,262,1684825200"; 
   d="scan'208";a="350137304"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2023 06:33:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="904770722"
X-IronPort-AV: E=Sophos;i="6.01,262,1684825200"; 
   d="scan'208";a="904770722"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.92.17.61])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 07 Aug 2023 06:33:14 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Shutemov, Kirill" <kirill.shutemov@intel.com>,
        "Dave Hansen" <dave.hansen@intel.com>
Subject: Re: SGX Memory Reservation on SPR
References: <ce32998f-1d7f-9481-ddb8-961b5d0f6a83@intel.com>
Date:   Mon, 07 Aug 2023 08:33:09 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.19a6ljf3wjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <ce32998f-1d7f-9481-ddb8-961b5d0f6a83@intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Dave
On Fri, 04 Aug 2023 16:06:50 -0500, Dave Hansen <dave.hansen@intel.com>  
wrote:

> What choices do our end users have about how much EPC RAM to dedicate to
> SGX on SPR systems?  I assume there's some ability to tweak to tweak it
> in the BIOS.

On one platform I know, BIOS provides choices from 256M to 256G, doubling  
at each increment. This should depend on OEM/BIOS and available total RAM  
configured.

BR
Haitao
