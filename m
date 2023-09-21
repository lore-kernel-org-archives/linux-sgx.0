Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC92E7D0AA
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Sep 2023 20:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjIUUpf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Sep 2023 16:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbjIUUpS (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 21 Sep 2023 16:45:18 -0400
Received: from icts-p-cavspool-1.kulnet.kuleuven.be (icts-p-cavspool-1.kulnet.kuleuven.be [134.58.240.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A295A8C633;
        Thu, 21 Sep 2023 10:42:34 -0700 (PDT)
Received: from icts-p-cavuit-2.kulnet.kuleuven.be (icts-p-cavuit-2.kulnet.kuleuven.be [IPv6:2a02:2c40:0:c0::25:131])
        by icts-p-cavspool-1.kulnet.kuleuven.be (Postfix) with ESMTP id AAC4529CB;
        Thu, 21 Sep 2023 16:37:18 +0200 (CEST)
X-KULeuven-Envelope-From: jo.vanbulck@cs.kuleuven.be
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: CB7D8201B4.ABFAB
X-KULeuven-Information: Katholieke Universiteit Leuven
Received: from icts-p-ceifnet-smtps-0.kuleuven.be (icts-p-ceifnet-smtps.service.icts.svcd [IPv6:2a02:2c40:0:51:140:242:ac11:1d])
        by icts-p-cavuit-2.kulnet.kuleuven.be (Postfix) with ESMTP id CB7D8201B4;
        Thu, 21 Sep 2023 16:36:40 +0200 (CEST)
BCmilterd-Mark-Subject: no
BCmilterd-Errors: 
BCmilterd-Report: SA-HVU#DKIM_VALID#0.00,SA-HVU#DKIM_SIGNED#0.00,SA-HVU#DKIM_VALID_AU#0.00
X-CAV-Cluster: smtps
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.kuleuven.be;
        s=cav; t=1695307000;
        bh=wb0qOjYa0NLZXWs/au0QyqK7ZnXXS/M96J9imzOO2PU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Og5+Jq3bNEQZTu/6u2h7bChIY83yb1040fJ2v1OSfc8F8lzeLXgpqbD4wPG6vXnya
         JPLTyJFNbWUJ5m+IlIrJtkrEiYQoekvFw2PHAG4rHdFNKLSN8f+rpw2KiXB7iQB0VC
         eOcJNJ53kTbaFTkHljGdPQ0YRYyr/kOeehvPDajY=
Received: from localhost.localdomain (ptr-82s0fs8p4onqm1q5sl7.18120a2.ip6.access.telenet.be [IPv6:2a02:1811:d31:8b00:c962:1db3:c9ed:fdfb])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by icts-p-ceifnet-smtps-0.kuleuven.be (Postfix) with ESMTPSA id 9126FD4F30837;
        Thu, 21 Sep 2023 16:36:40 +0200 (CEST)
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From:   Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
To:     jarkko@kernel.org, kai.huang@intel.com, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@linux.intel.com,
        Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Subject: [PATCH v6 12/13] selftests/sgx: Discard unsupported ELF sections
Date:   Thu, 21 Sep 2023 16:36:03 +0200
Message-Id: <20230921143604.6561-13-jo.vanbulck@cs.kuleuven.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230921143604.6561-1-jo.vanbulck@cs.kuleuven.be>
References: <20230921143604.6561-1-jo.vanbulck@cs.kuleuven.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Building the test enclave with -static-pie may produce a dynamic symbol
table, but this is not supported for enclaves and any relocations need to
happen manually (e.g., as for "encl_op_array"). Thus, opportunistically
discard ".dyn*" and ".gnu.hash" which the enclave loader cannot handle.

Signed-off-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 tools/testing/selftests/sgx/test_encl.lds | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/sgx/test_encl.lds b/tools/testing/selftests/sgx/test_encl.lds
index 333a3e78fdc9..ffe851a1cac4 100644
--- a/tools/testing/selftests/sgx/test_encl.lds
+++ b/tools/testing/selftests/sgx/test_encl.lds
@@ -33,6 +33,8 @@ SECTIONS
 		*(.note*)
 		*(.debug*)
 		*(.eh_frame*)
+		*(.dyn*)
+		*(.gnu.hash)
 	}
 }
 
-- 
2.25.1

