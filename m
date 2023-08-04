Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38132C001DE
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Aug 2023 21:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjHDVIN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Aug 2023 17:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbjHDVIK (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 4 Aug 2023 17:08:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014604C3F
        for <linux-sgx@vger.kernel.org>; Fri,  4 Aug 2023 14:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691183242; x=1722719242;
  h=message-id:date:mime-version:to:from:subject:
   content-transfer-encoding;
  bh=FdV+yjiUlL5iuKkhQAN6Qg0ybY4hxCBAYbsJqXWFDZo=;
  b=nmHavoFg+OmVp7OUkPlIZhEdzubbUg/OxR77ZITsbfwdjyMIvBAhmiBx
   3xKBKcLScDbiXmC7DJDlCoekDXJyfdBox9tMYInNNl3TYblhVe1eq50r7
   OCTcsq4H6z+976j0EYpYqbaFdJgCKH2UKY/PoSlNgiLAiyy65HfZ/KMmR
   Xk8dWAb+8KIRGVqN3yBN2bNCX4LL9Q0e9GvdKYguM7PMyrHea6dvuOb3M
   hIKHLbjxi6KXm47dz+axM+wdDQ3w64iu7wO0bf1y5+7eRcE+cLf2lqCwn
   I/MFp5hUA+OK+kx7PsmUenPL0arUK0q7SwZA5PfTyoYpCyeD3Y/ywAwsa
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10792"; a="401204580"
X-IronPort-AV: E=Sophos;i="6.01,256,1684825200"; 
   d="scan'208";a="401204580"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2023 14:06:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10792"; a="730200740"
X-IronPort-AV: E=Sophos;i="6.01,256,1684825200"; 
   d="scan'208";a="730200740"
Received: from lnstern-mobl1.amr.corp.intel.com (HELO [10.209.39.254]) ([10.209.39.254])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2023 14:06:50 -0700
Message-ID: <ce32998f-1d7f-9481-ddb8-961b5d0f6a83@intel.com>
Date:   Fri, 4 Aug 2023 14:06:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Shutemov, Kirill" <kirill.shutemov@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: SGX Memory Reservation on SPR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

What choices do our end users have about how much EPC RAM to dedicate to
SGX on SPR systems?  I assume there's some ability to tweak to tweak it
in the BIOS.
