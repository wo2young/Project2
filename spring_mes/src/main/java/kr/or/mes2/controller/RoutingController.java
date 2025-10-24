package kr.or.mes2.controller;

import java.io.File;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import kr.or.mes2.dto.RoutingDTO;
import kr.or.mes2.service.RoutingService;

@Controller
@RequestMapping("/master/routing")
public class RoutingController {

    @Autowired
    private RoutingService service;

    @GetMapping
    public String routingMain(@RequestParam(required = false) String keyword,
                              @RequestParam(required = false) Integer itemId,
                              Model model) {

        List<RoutingDTO> list = service.list(keyword, itemId);
        model.addAttribute("routingList", list);
        model.addAttribute("itemOptions", service.getItemOptions());
        model.addAttribute("equipOptions", service.getEquipOptions());
        model.addAttribute("keyword", keyword);
        model.addAttribute("selectedItemId", itemId);

        return "master/routing";
    }

    @PostMapping("/add")
    @ResponseBody
    public String insert(@ModelAttribute RoutingDTO dto,
                         @RequestParam(value = "imgFile", required = false) MultipartFile imgFile) {
        try {
            String uploadDir = "C:/mes_3/upload/routing/";
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            if (imgFile != null && !imgFile.isEmpty()) {
                String original = imgFile.getOriginalFilename();
                String ext = original.substring(original.lastIndexOf("."));
                String savedName = UUID.randomUUID().toString() + ext;
                File dest = new File(uploadDir, savedName);
                imgFile.transferTo(dest);
                dto.setImgPath("/upload/routing/" + savedName);
            }

            int result = service.insert(dto);
            return result > 0 ? "success" : "fail";

        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }

    @PostMapping("/edit")
    @ResponseBody
    public String update(@ModelAttribute RoutingDTO dto,
                         @RequestParam(value = "imgFile", required = false) MultipartFile imgFile) {
        try {
            String uploadDir = "C:/mes_3/upload/routing/";
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            if (imgFile != null && !imgFile.isEmpty()) {
                String original = imgFile.getOriginalFilename();
                String ext = original.substring(original.lastIndexOf("."));
                String savedName = UUID.randomUUID().toString() + ext;
                File dest = new File(uploadDir, savedName);
                imgFile.transferTo(dest);

                if (dto.getImgPath() != null && !dto.getImgPath().isEmpty()) {
                    File oldFile = new File("C:/mes_3" + dto.getImgPath().replace("/", "\\"));
                    if (oldFile.exists()) oldFile.delete();
                }

                dto.setImgPath("/upload/routing/" + savedName);
            }

            int result = service.update(dto);
            return result > 0 ? "success" : "fail";

        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }

    @PostMapping("/delete")
    @ResponseBody
    public String delete(@RequestParam int routingId) {
        try {
            RoutingDTO dto = service.getRoutingDetail(routingId);
            int result = service.delete(routingId);

            if (result > 0 && dto != null && dto.getImgPath() != null) {
                File oldFile = new File("C:/mes_3" + dto.getImgPath().replace("/", "\\"));
                if (oldFile.exists()) oldFile.delete();
            }
            return result > 0 ? "success" : "fail";

        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }

    @GetMapping("/detail")
    @ResponseBody
    public RoutingDTO getDetail(@RequestParam("routingId") int routingId) {
        try {
            return service.getRoutingDetail(routingId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
