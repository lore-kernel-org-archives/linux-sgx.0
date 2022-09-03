Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0180BC38145
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Sep 2022 06:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbiICGBd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Sep 2022 02:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiICGBc (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 3 Sep 2022 02:01:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9652218B2B
        for <linux-sgx@vger.kernel.org>; Fri,  2 Sep 2022 23:01:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3253660B66
        for <linux-sgx@vger.kernel.org>; Sat,  3 Sep 2022 06:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F85DC433C1;
        Sat,  3 Sep 2022 06:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662184890;
        bh=1NeSkGQ1YrCn+qFk2TzL4LhWFeSAR7JtsHBrKdPjOl8=;
        h=From:To:Cc:Subject:Date:From;
        b=HIIi1bYOmiDoUkUrYGWuy4/P48igPIlTlozBo2AwjHAc0BAAe98qiFKXsyGo8nAm6
         PERyN5h9/xwXS227ILkT4NByeAV0exPLPy1jVlqrkQ81SoDqyGV2W7DF8AyGxeer8t
         INcev4C/gRxUUUxHgOproL8ITqJc81m8Vg9wYR/igCFrUTwZ+HBHfvOZEOklHkXWfA
         XQFQcN/b5tkCofZvLiTDyTjnKW9CcN3xrDBPtnuJ6xGPAFAZdlh65dXirRSTrZ8WFY
         I4l5rd7wVuyr8+ik4UjN3xvDi0npWTSQK+VhJwqoRyoR7IKhps0lWih6vsZi3IX6MS
         XxOu6tc7L5TfA==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 0/2] x86/sgx: Fixes for v6.0
Date:   Sat,  3 Sep 2022 09:01:06 +0300
Message-Id: <20220903060108.1709739-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Two critical fixes for v6.0.

Haitao Huang (1):
  x86/sgx: Handle VA page allocation failure for EAUG on PF.

Jarkko Sakkinen (1):
  x86/sgx: Do not fail on incomplete sanitization on premature stop of
    ksgxd

 arch/x86/kernel/cpu/sgx/encl.c |  5 ++++-
 arch/x86/kernel/cpu/sgx/main.c | 33 ++++++++++++++++++++++++++-------
 2 files changed, 30 insertions(+), 8 deletions(-)

-- 
2.37.2

